class AdminGuiderPage < SitePrism::Page
  set_url '/admin/locations/{location_id}/guiders'

  element :name, '.t-name'
  element :email, '.t-email'
  element :add, '.t-add'

  sections :guiders, '.t-guider' do
    element :name, '.t-guider-name'
    element :email, '.t-guider-email'
    element :toggle, '.t-toggle'
  end
end
