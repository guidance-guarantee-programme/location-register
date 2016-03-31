class LocationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.pensionwise_admin?
        scope.all
      elsif user.project_manager?
        scope.where(organisation: user.organisation_slug)
      else
        scope.none
      end
    end
  end

  def update?
    user.pensionwise_admin? || project_manager_user_and_organisation?
  end

  def index?
    true
  end

  def permitted_attributes
    [:hidden]
  end

  private

  def project_manager_user_and_organisation?
    (user.project_manager? && user.organisation_slug == record.organisation)
  end
end
