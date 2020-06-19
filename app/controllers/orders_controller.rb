class OrdersController < ApplicationController

  def create
    if params[:param_1] == "schedule"
      apartment = Apartment.find_by(["user_id = ?", current_user.id])
      schedule = Schedule.find(params[:apartment_id])
      order = Order.create!(apartment: apartment, amount: schedule.room.price.to_i, state: 'pending', user: current_user )
      authorize(order)
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: schedule.room.name,
          amount: schedule.room.price.to_i*100,
          currency: 'brl',
          quantity: 1
        }],
        success_url: order_url(order),
        cancel_url: order_url(order)
      )  
      order.update(checkout_session_id: session.id)
      redirect_to schedule_path(schedule)
    else
      apartment = Apartment.find(params[:apartment_id])
      order = Order.create!(apartment: apartment, amount: apartment.bill_cents, state: 'pending', user: current_user )
      authorize(order)
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: apartment.apt_number,
          amount: apartment.bill_cents*100,
          currency: 'brl',
          quantity: 1
        }],
        success_url: order_url(order),
        cancel_url: order_url(order)
      )  
      order.update(checkout_session_id: session.id)
      redirect_to new_order_payment_path(order, apartment_id: apartment.id)
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
