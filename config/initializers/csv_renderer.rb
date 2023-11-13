# frozen_string_literal: true

ActionController::Renderers.add :csv do |object, _|
  send_data object.csv, type: Mime[:csv], disposition: 'attachment; filename=locations.csv'
end
