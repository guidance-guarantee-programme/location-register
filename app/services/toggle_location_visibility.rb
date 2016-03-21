class ToggleLocationVisibility
  attr_reader :location

  def initialize(uid:)
    @location = Location.find_by(
      uid: uid,
      state: 'current'
    )
  end

  def toggle
    location.update_attributes!(state: 'old')

    Location.create!(
      params.merge(
        'state' => 'current',
        'hidden' => !location.hidden,
        'version' => location.version + 1
      )
    )
  end

  private

  def params
    location.attributes.except('id', 'created_at', 'updated_at')
  end
end
