class LocationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.project_manager?
        scope.where(organisation: user.organisation_slug)
      else
        scope.none
      end
    end
  end

  def update?
    user.project_manager? && record.organisation == user.organisation_slug
  end

  def index?
    true
  end

  def permitted_attributes
    [:hidden]
  end
end
