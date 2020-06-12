class ScheduleMailer < ApplicationMailer
    helper :application
    default from: "timaia.realestate@gmail.com"

    def room_scheduled
        @schedule = params[:schedule]
        @user = params[:user]

        mail(to: @user.email, subject: "#{@schedule.room.building.building_name} - New schedule confirmation at #{@schedule.room.name}")
    end
end
