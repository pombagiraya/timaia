class BuildingsController < ApplicationController
  before_action :find_building, only: [:show, :destroy, :edit, :update]

  def index
    @buildings = policy_scope(Building)
  end

  def show
  end

  def new
    @building = Building.new
    authorize(@building)
  end

  def edit
  end

  def import
    Apartment.import(params[:file])
    redirect_to root_url, notice: "Apartments imported."
  end

  def update
    @building.update(building_params)
    if @building.save
      redirect_to buildings_path
    else
      render :edit
    end
  end

  def create
    @building = Building.new(building_params)
    authorize(@building)
    @building.user = current_user
    if @building.save
      redirect_to buildings_path
    else
      render :new
    end
  end

  def destroy
    @building.destroy
    redirect_to buildings_path
  end

  private

  def find_building
    @building = Building.find(params[:id])
    authorize(@building)
  end

  def building_params
    params.require(:building).permit(:building_name, :super_name, :super_email, :zipcode, :city, :province, :country)
  end
end
