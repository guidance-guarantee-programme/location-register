class Guider < ApplicationRecord
  belongs_to :location

  has_many :guider_assignments
  has_many :locations, through: :guider_assignments
end
