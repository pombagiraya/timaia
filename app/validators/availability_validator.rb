class AvailabilityValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)

      schedule = Schedule.find_by(["id = ?", record.id])
      unless schedule.start_time == record.start_time && schedule.end_time == record.end_time
        schedules = Schedule.where(["room_id = ?", record.room_id])
        date_ranges = schedules.map { |b| b.start_time..b.end_time }
        date_ranges.each do |range|
          if range.include? value
            record.errors.add(attribute, "not available")
          end
        end
      end
    end
  end