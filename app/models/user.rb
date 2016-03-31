class User < ActiveRecord::Base
  include GDS::SSO::User

  serialize :permissions, Array

  def pensionwise_admin?
    permissions.include?('pensionwise_admin')
  end

  def project_manager?
    permissions.include?('project_manager')
  end
end
