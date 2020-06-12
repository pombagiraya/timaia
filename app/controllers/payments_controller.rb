class PaymentsController < ApplicationController
    before_action :find_payment, only: [:destroy, :edit, :update, :show]
    before_action :find_apartment, only: [:create, :index, :show]

    def index
      @payments = policy_scope(Payment)
    end
  
    def show
      @apartment = Apartment.find(@payment.apartment.id)
    end
  
    def new
      @order = current_user.orders.where(state: 'pending').find(params[:order_id])
      authorize(@order)
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
        flash[:notice] = "Payment created."
      else
        render :new
      end
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
        flash[:notice] = "Payment updated."
      else
        render :edit
      end      
    end

    def new_order
      raise
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
