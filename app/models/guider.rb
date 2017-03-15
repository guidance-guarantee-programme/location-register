class Guider < ApplicationRecord
  has_many :guider_assignments
  has_many :locations, through: :guider_assignments
end
