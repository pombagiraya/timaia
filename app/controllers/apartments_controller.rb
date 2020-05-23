class ApartmentsController < ApplicationController
  before_action :find_apartment, only: [:destroy, :edit, :update, :show]
  before_action :find_building, only: [:new, :create, :index]

  def index
    @apartments = Apartment.all
    # @apartments = policy_scope(Apartment).all -- Quando tiver pundit
  end

  def show
    @building = Building.find(@apartment.building.id)
    @unpaid = 0
    @unpaid_delay = 0
    @apartment.payments.each do |payment|
      if payment.status == 0 && payment.payment_date <= Date.today
        @unpaid += 1
        @unpaid_delay +=1
      elsif payment.status == 0
        @unpaid += 1
      end
    end
    @unpaid *= @apartment.bill
    @unpaid_delay *= @apartment.bill
  end

  def new
    @apartment = Apartment.new
    @users = User.all
    authorize(@apartment)
  end

  def edit
    @users = User.all
  end

  def create
    @apartment = Apartment.new(apartment_params)
    @apartment.building = @building
    authorize(@apartment)
    @apartment.user = current_user
    if @apartment.save
      redirect_to building_path(@apartment.building_id)
    else
      render :new
    end
  end

  def destroy
    @apartment.destroy
    redirect_to building_path(@apartment.building_id)
  end

  def update
    @apartment.update(apartment_params)
    if @apartment.save
      redirect_to building_path(@apartment.building_id)
    else
      render :edit
    end
  end

  private

  def find_apartment
    @apartment = Apartment.find(params[:id])
    authorize(@apartment)
  end

  def find_building
    @building = Building.find(params[:building_id])
  end

  def apartment_params
    params.require(:apartment).permit(:apt_number, :bill, :user_id)
  end
end
