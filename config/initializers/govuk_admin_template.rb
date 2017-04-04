GovukAdminTemplate.environment_style = Rails.env.staging? ? 'preview' : ENV['RAILS_ENV']
GovukAdminTemplate.environment_label = Rails.env.titleize

GovukAdminTemplate.configure do |c|
  c.app_title = 'CAB Locator'
  c.show_flash = true
  c.show_signout = false
end
