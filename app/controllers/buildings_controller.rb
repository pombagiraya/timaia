class BuildingsController < ApplicationController
  before_action :find_building, only: [:show, :destroy, :edit, :update]

  def index
    @buildings = policy_scope(Building).all
    @buildings.each do |building|
      default_rate = 0
      building.apartments.each do |apartment|
        apto_unpaid = 0
        apartment.payments.each do |payment|
          if payment.status == 0
            apto_unpaid += apartment.bill
          end
        end
        default_rate += 1 if apto_unpaid > 0
      end
      @default_rate = (default_rate*1.00 / building.apartments.count*1.00)* 100.0
    end
  end

  def show
    @unpaid = 0
    @unpaid_delay = 0
    default_rate = 0
    @building.apartments.each do |apartment|
      apto_unpaid = 0
      apartment.payments.each do |payment|
        if payment.status == 0 && payment.payment_date <= Date.today
          @unpaid += apartment.bill
          @unpaid_delay += apartment.bill
          apto_unpaid += apartment.bill
        elsif payment.status == 0
          @unpaid += apartment.bill
          apto_unpaid += apartment.bill
        end
      end
      default_rate += 1 if apto_unpaid > 0
    end
    @default_rate = (default_rate*1.00 / @building.apartments.count*1.00)* 100.0
  end

  def new
    @building = Building.new
    authorize(@building)
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
