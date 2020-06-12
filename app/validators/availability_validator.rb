class AvailabilityValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      schedules = Schedule.where(["room_id =?", record.room_id])
      date_ranges = schedules.map { |b| b.start_time..b.end_time }
  
      date_ranges.each do |range|
        if range.include? value
          record.errors.add(attribute, "not available")
        end
      end
    end
  end