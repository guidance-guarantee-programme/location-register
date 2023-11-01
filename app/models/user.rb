class User < ApplicationRecord
  include GDS::SSO::User

  serialize :permissions, Array

  def pensionwise_admin?
    permissions.include?('pensionwise_admin')
  end

  def project_manager?
    permissions.include?('project_manager')
  end

  def cita_england_and_wales?
    organisation_slug == 'cita'.freeze
  end
end
