require_relative "../../lib/omniauth/facebook.rb"

class User < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :places, through: :reviews

  has_many :friendships, foreign_key: :user_id, dependent: :destroy
  has_many :reverse_friendships, class_name: :Friendship, foreign_key: :friend_id, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # recursively add new friends from your friends list
  # make requests to the facebook api for friends
  # iterate over response and create friendship records
  # repeat until the response is empty
  def add_friends(token,next_url=nil)
    response = Omniauth::Facebook.get_friends(token,next_url)
    total_count = response["summary"]["total_count"]
    return if response["data"].empty?
    return if (total_count.nil? || self.friends.count >= total_count)

    response["data"].each do |f|
      friend = User.find_by_uid(f["id"])
      if friend
        Friendship.find_or_create_by(user_id: self.id, friend_id: friend.id)
      end
    end
 
    if response["paging"]["next"]
      add_friends(token,response["paging"]["next"])
    end
  end

  def update_auth_token(token)
    update_attributes(auth_token: token) unless token == auth_token
  end

  def self.from_omniauth(auth)
    where(provider: auth["provider"], uid: auth["uid"]).first_or_initialize.tap do |user|
      user.email = "user_#{auth["uid"]}@belinko.com"
      user.password = Devise.friendly_token[0,20]
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.auth_token = auth["token"]
      user.save
      # user.name = auth.info.name   # assuming the user model has a name
    end
    
  end



  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
