class ApartmentsController < ApplicationController
  before_action :find_apartment, only: [:destroy, :edit, :update, :show]
  before_action :find_building, only: [:new, :create ]

  def index
    @apartments = policy_scope(Apartment)
    respond_to do |format|
      format.html
      format.csv { send_data @apartments.to_csv }
      format.xls { send_data @apartments.to_csv(col_sep: "\t"), row_sep: "\n" }
    end
  end

  def show
    @building = Building.find(@apartment.building.id)
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

  def user_apartment
    user = current_user.id
    Apartment.search(user)
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

  def find_apartments(user_id)
    @apartments = Apartment.where(user_id: params[:user_id])
  end
end
