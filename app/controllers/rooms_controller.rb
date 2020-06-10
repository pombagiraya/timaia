class RoomsController < ApplicationController
  before_action :find_room, only: [:destroy, :edit, :update, :show]
  before_action :find_building, only: [:new, :create]

  def index
    @rooms = @building.rooms
    @rooms = policy_scope(Room)
  end

  def show
    @building = Building.find(@room.building.id)
  end

  def new
    @room = Room.new
    authorize(@room)
  end

  def edit
  end

  def create
    @room = Room.new(room_params)
    @room.building = @building
    authorize(@room)
    if @room.save
      redirect_to building_path(@room.building_id)
      flash[:notice] = "Room created."
    else
      render :new
    end    
  end

  def destroy
    @room.destroy
    redirect_to building_path(@room.building_id)
    flash[:notice] = "Room deleted."
  end

  def update
    @room.update(room_params)
    if @room.save
      redirect_to building_path(@room.building_id)
      flash[:notice] = "Room updated."
    else
      render :edit
    end    
  end 

  private

  def find_room
    @room = Room.find(params[:id])
    authorize(@room)
  end

  def find_building
    @building = Building.find(params[:building_id])
  end

  def room_params
    params.require(:room).permit(:name, :price)
  end
end