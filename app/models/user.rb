class User < ActiveRecord::Base
  include GDS::SSO::User

  serialize :permissions, Array

  def project_manager?
    permissions.include?('project_manager')
  end
end
