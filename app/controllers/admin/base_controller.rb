module Admin
  class BaseController < ApplicationController
    layout 'admin/application'

    include Pundit
    include GDS::SSO::ControllerMethods

    before_action :require_signin_permission!
  end
end
