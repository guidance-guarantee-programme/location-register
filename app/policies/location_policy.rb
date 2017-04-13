class LocationPolicy < ApplicationPolicy
  ADMIN_PARAMS = %i(
    organisation
    twilio_number
    online_booking_twilio_number
    online_booking_enabled
    online_booking_reply_to
  ).freeze

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

  def admin?
    user.pensionwise_admin?
  end

  def phone?
    record.version.nil? || (record.version == 1 && record.new_record?) || admin?
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

  def create?
    admin_or_organisations_project_manager?
  end

  def online_booking?
    admin?
  end

  def permitted_attributes
    base_params = [
      :booking_location_uid,
      :hidden,
      :title,
      :hours,
      address: [:address_line_1, :address_line_2, :address_line_3, :town, :county, :postcode]
    ]

    base_params += [:phone] if creating_new_record? || admin?
    base_params += ADMIN_PARAMS if admin?
    base_params
  end

  private

  def creating_new_record?
    record == Location
  end

  def admin_or_organisations_project_manager?
    admin? || (user.project_manager? && user.organisation_slug == record.organisation)
  end
end
