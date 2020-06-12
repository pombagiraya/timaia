class SchedulesController < ApplicationController
  before_action :find_schedule, only: [:destroy, :edit, :update, :show]
  before_action :find_room, only: [:new, :create]

  def index
    @schedules = policy_scope(Schedule.where(user_id: current_user.id))
  end

  def show
  end

  def new
    @schedule = Schedule.new
    authorize(@schedule)
    @building = @room.building
    @apartments = Apartment.where(building_id: @room.building.id)
    @users = []
    @apartments.each do |apartment|
      @users << apartment.user
    end
  end

  def edit
    @apartments = Apartment.where(building_id: @schedule.room.building.id)
    @building = @schedule.room.building
    @users = []
    @apartments.each do |apartment|
      @users << apartment.user
    end
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.room = @room
    @schedule.user = current_user if @schedule.user.nil?
    authorize(@schedule)
    if @schedule.save
      ScheduleMailer.with(schedule: @schedule, user: current_user).room_scheduled.deliver_now!
      redirect_to room_path(@room.id)
      flash[:notice] = "Schedule created."
    else
      @apartments = Apartment.where(building_id: @room.building.id)
      @users = []
      @apartments.each do |apartment|
        @users << apartment.user
      end
      render :new
    end 
  end

  def destroy
    @schedule.destroy
    redirect_to room_path(@schedule.room.id)
    flash[:notice] = "Schedule deleted."
  end

  def update
    @schedule.update(schedule_params)
    if @schedule.save
      redirect_to room_path(@schedule.room.id)
      flash[:notice] = "Schedule updated."
    else
      @apartments = Apartment.where(building_id: @schedule.room.building.id)   
      @users = []
      @apartments.each do |apartment|
        @users << apartment.user
      end
      render :edit
    end    
  end 

  def user_schedules
    user = current_user.id
    Schedule.search(user)
  end

  private

  def find_schedule
    @schedule = Schedule.find(params[:id])
    authorize(@schedule)
  end

  def find_room
    @room = Room.find(params[:room_id])
  end

  def schedule_params
    params.require(:schedule).permit(:user_id, :room_id, :start_time, :end_time)
  end

  def find_schedules(user_id)
    @schedules = Schedule.where(user_id: params[:user_id])
  end
end