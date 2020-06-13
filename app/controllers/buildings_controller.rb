require 'pry'
class BuildingsController < ApplicationController
  before_action :find_building, only: [:show, :destroy, :edit, :update]
  before_action :skip_authorization, only: [:import, :export]

  def index
    @buildings = Building.geocoded
    @buildings = policy_scope(Building).all
    @markers = @buildings.map do |building|
      {
        lat: building.latitude,
        lng: building.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { building: building }),
        image_url: helpers.asset_url("building-ico.png")
      }
    end
  end

  def show
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
      flash[:notice] = "Building updated."
    else
      render :edit
    end    
  end

  def create
    @building = Building.new(building_params)
    authorize(@building)
    @building.user = current_user
    usersuper = User.new
    usersuper.name = @building.super_name
    usersuper.email = @building.super_email
    usersuper.password = '123456'
    usersuper.role = 3
    usersuper.save!
    if @building.save
      redirect_to buildings_path
      flash[:notice] = "Building created."
    else
      render :new
    end    
  end

  def destroy
    @building.destroy
    redirect_to buildings_path
    flash[:notice] = "Building deleted."
  end

  def import
    Building.import(params[:file])
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Apartments imported."
  end

  def export
    @building = Building.find(params[:building_id])
    name = @building.building_name
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    i = 1
    worksheet.add_cell(0, 0, 'Building')
    worksheet.add_cell(0, 1, 'Apto Number')
    worksheet.add_cell(0, 2, 'Bill ($)')
    worksheet.add_cell(0, 3, 'Owner Name')
    worksheet.add_cell(0, 4, 'Owner E-mail')
    if @building.apartments.count > 0
      @building.apartments.each do |apartment|
        worksheet.add_cell(i, 0, name)
        worksheet.add_cell(i, 1, apartment.apt_number)
        worksheet.add_cell(i, 2, apartment.bill_cents)
        worksheet.add_cell(i, 3, apartment.user.name)
        worksheet.add_cell(i, 4, apartment.user.email)
        i += 1
      end
    else
      worksheet.add_cell(1, 0, name)
      worksheet.add_cell(1, 1, '')
      worksheet.add_cell(1, 2, '')
      worksheet.add_cell(1, 3, '')
      worksheet.add_cell(1, 4, '')
    end
    respond_to do |format|
      format.xlsx { send_data workbook.stream.read, filename: "#{@building.building_name}.xlsx" }
    end
    flash[:notice] = "Apartments exported."
  end

  private

  def find_building
    @building = Building.find(params[:id])
    authorize(@building)
  end

  def building_params
    params.require(:building).permit(:building_name, :super_name, :super_email, :zipcode, :city, :province, :country, :address, :address_number, :photo)
  end
end
