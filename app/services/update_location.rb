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
    if location.nil?
      Location.create!(
        params.merge(
          uid: uid,
          state: 'current',
          version: 1
        )
      )
    elsif matches(params)
      # no update required
      location
    else
      location.update_attributes!(state: 'old')
      Location.create!(
        params.merge(
          uid: uid,
          state: 'current',
          version: location.version + 1
        )
      )
    end
  end

  private

  def matches(params)
    params.all? do |key, value|
      [:created_at, :updated_at].include?(key.to_sym) ||
        (@location[key].blank? && value.blank?) ||
        @location[key] == value
    end
  end
end
