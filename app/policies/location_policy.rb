class LocationPolicy < ApplicationPolicy
  CITA_ENGLAND_AND_WALES_ORGANISATIONS = %w[cita_e cita_w nicab].freeze

  PROJECT_MANAGER_PARAMS = %i[
    twilio_number
    online_booking_twilio_number
    online_booking_reply_to
  ].freeze

  ONLINE_BOOKING_PARAMS = %i[online_booking_enabled realtime].freeze

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.pensionwise_admin?
        scope.all
      elsif user.project_manager?
        if user.cita_england_and_wales?
          scope.where(organisation: CITA_ENGLAND_AND_WALES_ORGANISATIONS)
        else
          scope.where(organisation: user.organisation_slug)
        end
      else
        scope.none
      end
    end
  end

  def admin?
    user.pensionwise_admin?
  end

  delegate :project_manager?, to: :user

  def online_booking?
    admin? || project_manager?
  end

  def phone?
    record.version.nil? || (record.version == 1 && record.new_record?) || admin_or_organisations_project_manager?
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

  def permitted_attributes
    base_params = [
      :booking_location_uid,
      :hidden,
      :title,
      :hours,
      :accessibility_information,
      { address: %i[address_line_1 address_line_2 address_line_3 town county postcode] }
    ]

    base_params += %i[phone organisation] if creating_new_record? || admin_or_organisations_project_manager?
    base_params += PROJECT_MANAGER_PARAMS if project_manager? || admin?
    base_params += ONLINE_BOOKING_PARAMS if online_booking?
    base_params
  end

  def admin_or_organisations_project_manager?
    return true if admin?
    return false unless project_manager?

    project_manager_ok?
  end

  private

  def creating_new_record?
    record == Location
  end

  def project_manager_ok?
    if user.cita_england_and_wales?
      CITA_ENGLAND_AND_WALES_ORGANISATIONS.include?(record.organisation)
    else
      user.organisation_slug == record.organisation
    end
  end
end
