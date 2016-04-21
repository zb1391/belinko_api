module GooglePlacesApi
  # This class is used for finding nearby places based on the 
  # radius/latitude/longitude
  # all three of those should be passed in as options to the constructor
  #
  # this is used in the GooglePlaceApi::Searcher class currently
  class BelinkoSearcher
    attr_reader :latitude,:longitude,:radius,:user_id
    
    def initialize(user_id,options = {})
      @radius = options[:radius]
      @latitude = options[:latitude]
      @longitude = options[:longitude]
      @user_id = user_id
    end

    # get all belinko places nearby
    def nearby_places
      return [] unless @radius && @latitude && @longitude
      radius_km = @radius.to_f/1000

      user = User.find(@user_id)
      ids = user.friends.pluck("id")
      ids << user_id
      Place.within(radius_km, origin: [@latitude,@longitude]).reviewed_by(ids)
    end
  end
end
