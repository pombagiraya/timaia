class PaymentsController < ApplicationController
    before_action :find_payment, only: [:destroy, :edit, :update, :show]
    before_action :find_apartment, only: [:new, :create, :index, :show]

    def index
      @payments = policy_scope(Payment)
    end
  
    def show
      @apartment = Apartment.find(@payment.apartment.id)
    end
  
    def new
      @payment = Payment.new
      authorize(@payment)
    end
  
    def edit
    end
  
    def create
      @payment = Payment.new(payment_params)
      @payment.apartment = @apartment
      @payment.status = 0
        # 0 não paga
        # 1 paga
      authorize(@payment)
      if @payment.save
        redirect_to apartment_path(params[:apartment_id])
      else
        render :new
      end
      flash[:notice] = "Payment created."
    end
  
    def destroy
      @payment.destroy
      redirect_to apartment_path(@payment.apartment_id)
      flash[:notice] = "Payment deleted."
    end
  
    def update
      @payment.update(payment_params)
      if @payment.save
        redirect_to apartment_path(@payment.apartment_id)
      else
        render :edit
      end
      flash[:notice] = "Payment updated."
    end
  
    private
  
    def find_payment
      @payment = Payment.find(params[:id])
      authorize(@payment)
    end
  
    def find_apartment
      @apartment = Apartment.find(params[:apartment_id])
    end
  
    def payment_params
      params.require(:payment).permit(:payment_date, :status)
    end
end
