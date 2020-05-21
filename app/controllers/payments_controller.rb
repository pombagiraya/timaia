class PaymentsController < ApplicationController
    before_action :find_payment, only: [:destroy, :edit, :update, :show]
    before_action :find_apartment, only: [:new, :create, :index, :show]

    def index
      @payments = Payment.all
      # @payments = policy_scope(Payment).all -- Quando tiver pundit
    end
  
    def show
      @apartment = Apartment.find(@payment.apartment.id)
    end
  
    def new
      @payment = Payment.new
      #authorize(@payment) -- Quando tiver pundit
    end
  
    def edit
    end
  
    def create
      @payment = Payment.new(payment_params)
      @payment.apartment = @apartment
      if @payment.payment_date > Date.today
        @payment.status = 0
      else
        @payment.status = 1
      end
        # 0 no prazo
        # 1 atrasada
        # 2 paga
      #authorize(@payment) -- Quando tiver pundit
      if @payment.save
        redirect_to apartment_path(params[:apartment_id])
      else
        render :new
      end
    end
  
    def destroy
      @payment.destroy
      redirect_to apartment_path(@payment.apartment_id)
    end
  
    def update
      @payment.update(payment_params)
      if @payment.save
        redirect_to apartment_path(@payment.apartment_id)
      else
        render :edit
      end
    end
  
    private
  
    def find_payment
      @payment = Payment.find(params[:id])
      #authorize(@payment) -- Quando tiver pundit
    end
  
    def find_apartment
      @apartment = Apartment.find(params[:apartment_id])
    end
  
    def payment_params
      params.require(:payment).permit(:payment_date, :status)
    end
end
