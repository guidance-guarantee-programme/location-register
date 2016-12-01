class EditedField
  class BookingLocationField < EditedField
    def old_value
      wrap(super)
    end

    def new_value
      wrap(super)
    end

    private

    def wrap(value)
      return '' if value.nil?

      value.title
    end
  end
end
