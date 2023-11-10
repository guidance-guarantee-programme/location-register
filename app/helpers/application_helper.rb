module ApplicationHelper
  def bootstrap_alert_class_for(flash_type)
    case flash_type.to_sym
    when :success
      'alert-success' # Green
    when :error
      'alert-danger' # Red
    when :alert
      'alert-warning' # Yellow
    when :notice
      'alert-info' # Blue
    else
      flash_type.to_s
    end
  end

  def error_messages_for(*objects)
    object_names = objects.map { |object| object.class.to_s.underscore }
    objects
      .map { |object| object.errors.messages.reject { |attribute, _| object_names.include?(attribute.to_s) } }
      .inject(&:merge)
      .sort_by(&:first)
  end

  def location_visibility_class(location)
    location.hidden? ? 'location__hidden' : 'location__visible'
  end

  def location_select_options
    return [] unless current_user
    locations = Pundit.policy_scope!(current_user, Location.current_by_visibility)
    locations.map do |location|
      [
        location.title,
        "#{location.uid}/edit",
        { 'data-hidden' => location.hidden? }
      ]
    end
  end
end
