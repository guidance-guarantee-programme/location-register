class Guider < ApplicationRecord
  HIDDEN = '[HIDDEN] '.freeze

  has_many :guider_assignments
  has_many :locations, through: :guider_assignments

  def hidden?
    name.to_s.starts_with?(HIDDEN)
  end

  def toggle_hidden!
    self.name = if hidden?
                  name.sub(HIDDEN, '')
                else
                  "#{HIDDEN}#{name}"
                end

    save!
  end
end
