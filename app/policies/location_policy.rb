class LocationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organisation: user.organisation_slug)
    end
  end

  def index?
    true
  end
end
