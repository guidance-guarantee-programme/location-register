class UpdateLocation
  attr_reader :uid, :location

  def initialize(uid:)
    @uid = uid
    @location = Location.find_by(
      uid: uid,
      state: 'current'
    )
  end

  def update!(params)
    return create!(params) if location.nil?
    return location if matches(params)

    location.update_attributes!(state: 'old')
    create!(params, location.version + 1)
  end

  private

  def create!(params, version = 1)
    Location.create!(
      params.merge(
        uid: uid,
        state: 'current',
        version: version
      )
    )
  end

  def matches(params)
    params.all? do |key, value|
      [:created_at, :updated_at].include?(key.to_sym) ||
        (@location[key].blank? && value.blank?) ||
        @location[key] == value
    end
  end
end
