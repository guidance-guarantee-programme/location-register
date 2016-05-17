# frozen_string_literal: true
ActionController::Renderers.add :csv do |object, _|
  send_data object.csv, type: Mime::CSV, disposition: 'attachment; filename=locations.csv'
end
