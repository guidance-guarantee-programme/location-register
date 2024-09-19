class Guider < ApplicationRecord
  INACTIVE = '[INACTIVE] '.freeze

  has_many :guider_assignments
  has_many :locations, through: :guider_assignments

  validates :name, presence: true

  def inactive?
    name.to_s.starts_with?(INACTIVE)
  end

  def toggle_hidden!
    self.name = if inactive?
                  name.sub(INACTIVE, '')
                else
                  "#{INACTIVE}#{name}"
                end

    save!
  end
end
