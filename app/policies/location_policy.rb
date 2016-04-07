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

  def edit?
    admin_or_organisations_project_manager?
  end

  def index?
    true
  end

  def show?
    admin_or_organisations_project_manager?
  end

  def update?
    admin_or_organisations_project_manager?
  end

  def permitted_attributes
    [
      :booking_location_uid,
      :hidden,
      :title,
      :hours,
      address: [:address_line_1, :address_line_2, :address_line_3, :town, :county, :postcode]
    ]
  end

  private

  def admin_or_organisations_project_manager?
    user.pensionwise_admin? || (user.project_manager? && user.organisation_slug == record.organisation)
  end
end
