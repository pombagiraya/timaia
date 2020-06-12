# Preview all emails at http://localhost:3000/rails/mailers/schedule_mailer
class ScheduleMailerPreview < ActionMailer::Preview

    def room_scheduled
        ScheduleMailer.with(schedule: Schedule.first, user: User.first).room_scheduled
    end
end
