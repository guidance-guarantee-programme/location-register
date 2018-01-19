module Admin
  class BaseController < ApplicationController
    layout 'admin/application'

    include Pundit
    include GDS::SSO::ControllerMethods

    before_action :authenticate_user!
  end
end
