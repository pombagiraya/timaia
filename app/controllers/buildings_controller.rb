class BuildingsController < ApplicationController
  before_action :find_building, only: [:show, :destroy, :edit]

  def index
    @buildings = Building.all
    # @buildings = policy_scope(Building).all -- Quando tiver pundit
  end

  def show
  end

  def new
    @building = Building.new
    # authorize(@building) -- Quando tiver pundit
  end

  def create
    @building = Building.new(building_params)
    # authorize(@building) -- Quando tiver pundit
    @building.user = current_user

    if @building.save
      redirect_to buildings_path
    else
      render :new
    end
  end

  def edit; end

  def update
    @building = Building.find(params[:id])
    @building.update(building_params)
    # no need for app/views/buildings/update.html.erb
    redirect_to building_path(@building)
  end

  def destroy
    @building.destroy
    redirect_to buildings_path
  end

  private

  def find_building
    @building = Building.find(params[:id])
    #authorize(@building) -- Quando tiver pundit
  end

  def building_params
    params.require(:building).permit(:building_name, :super_name, :super_email, :zipcode, :city, :province, :country)
  end
end
