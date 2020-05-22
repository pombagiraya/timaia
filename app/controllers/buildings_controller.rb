class BuildingsController < ApplicationController
  before_action :find_building, only: [:show, :destroy, :edit, :update]

  def index
    @buildings = Building.all
    # @buildings = policy_scope(Building).all -- Quando tiver pundit
  end

  def show
    @unpaid = 0
    @unpaid_delay = 0
    @building.apartments.each do |apartment|
      apartment.payments.each do |payment|
        if payment.status == 0 && payment.payment_date <= Date.today
          @unpaid += apartment.bill
          @unpaid_delay += apartment.bill
        elsif payment.status == 0 
          @unpaid += apartment.bill
        end
      end
    end
  end

  def new
    @building = Building.new
    #authorize(@building) -- Quando tiver pundit
  end

  def edit
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
    #authorize(@building) -- Quando tiver pundit
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
    #authorize(@building) -- Quando tiver pundit
  end

  def building_params
    params.require(:building).permit(:building_name, :super_name, :super_email, :zipcode, :city, :province, :country)
  end
end
