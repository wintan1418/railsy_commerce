class CheckoutsController < ApplicationController
  include CartManagement

  allow_unauthenticated_access
  layout "checkout"

  before_action :ensure_cart_has_items, only: %i[show update apply_coupon remove_coupon apply_gift_card remove_gift_card]
  helper_method :applied_coupon, :coupon_discount_cents, :coupon_error,
                :applied_gift_card, :gift_card_discount_cents, :gift_card_error

  def show
    @step = "address"
    @shipping_methods = ShippingMethod.active
    @address = current_user&.addresses&.last || Address.new
  end

  def apply_coupon
    code = params[:code].to_s.strip.upcase
    result = Discounts::ValidateCodeService.call(
      code: code,
      subtotal_cents: current_cart.subtotal.cents,
      user: current_user
    )

    if result.success?
      session[:checkout_coupon_code] = code
      session.delete(:checkout_coupon_error)
    else
      session.delete(:checkout_coupon_code)
      session[:checkout_coupon_error] = result.errors.first
    end

    redirect_to checkout_path
  end

  def remove_coupon
    session.delete(:checkout_coupon_code)
    session.delete(:checkout_coupon_error)
    redirect_to checkout_path
  end

  def apply_gift_card
    code = params[:code].to_s.strip.upcase
    card = GiftCard.active.find_by(code: code)

    if card.nil?
      session.delete(:checkout_gift_card_code)
      session[:checkout_gift_card_error] = "Invalid gift card code"
    elsif !card.available?
      session.delete(:checkout_gift_card_code)
      session[:checkout_gift_card_error] = if card.expired?
        "This gift card has expired"
      elsif card.depleted?
        "This gift card has no remaining balance"
      else
        "This gift card isn't active"
      end
    else
      session[:checkout_gift_card_code] = code
      session.delete(:checkout_gift_card_error)
    end

    redirect_to checkout_path
  end

  def remove_gift_card
    session.delete(:checkout_gift_card_code)
    session.delete(:checkout_gift_card_error)
    redirect_to checkout_path
  end

  def update
    case params[:step]
    when "address"
      handle_address_step
    when "shipping"
      handle_shipping_step
    when "payment"
      handle_payment_step
    else
      redirect_to checkout_path
    end
  end

  def confirm
    @order = Order.find_by!(number: params[:order_number])
  end

  private

  def applied_coupon
    return nil unless session[:checkout_coupon_code].present?
    @applied_coupon ||= Discount.active.find_by(code: session[:checkout_coupon_code])
  end

  def coupon_discount_cents
    return 0 unless applied_coupon
    result = Discounts::ValidateCodeService.call(
      code: applied_coupon.code,
      subtotal_cents: current_cart.subtotal.cents,
      user: current_user
    )
    result.success? ? result.payload[:discount_cents] : 0
  end

  def coupon_error
    session[:checkout_coupon_error]
  end

  def applied_gift_card
    return nil unless session[:checkout_gift_card_code].present?
    @applied_gift_card ||= GiftCard.active.find_by(code: session[:checkout_gift_card_code])
  end

  def gift_card_discount_cents
    return 0 unless applied_gift_card&.available?
    subtotal_after_coupon = current_cart.subtotal.cents - coupon_discount_cents
    applied_gift_card.usable_amount_cents(subtotal_after_coupon)
  end

  def gift_card_error
    session[:checkout_gift_card_error]
  end

  def ensure_cart_has_items
    redirect_to cart_path, alert: "Your cart is empty." if current_cart.empty?
  end

  def handle_address_step
    @address = Address.new(address_params)
    @address.user = current_user

    if @address.save
      session[:checkout_shipping_address_id] = @address.id
      session[:checkout_billing_address_id] = @address.id
      session[:checkout_email] = params[:email].presence || current_user&.email_address || @address.user&.email_address

      if current_cart.digital_only?
        session.delete(:checkout_shipping_method_id)
        @step = "payment"
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("checkout_steps", partial: "checkouts/steps/payment", locals: { shipping_method: nil }) }
          format.html { render :show }
        end
        return
      end

      @shipping_methods = ShippingMethod.active
      @step = "shipping"

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("checkout_steps", partial: "checkouts/steps/shipping", locals: { shipping_methods: @shipping_methods }) }
        format.html { render :show }
      end
    else
      @step = "address"
      @shipping_methods = ShippingMethod.active

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("checkout_steps", partial: "checkouts/steps/address", locals: { address: @address }) }
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  def handle_shipping_step
    @shipping_method = ShippingMethod.find(params[:shipping_method_id])
    session[:checkout_shipping_method_id] = @shipping_method.id

    @step = "payment"

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("checkout_steps", partial: "checkouts/steps/payment", locals: { shipping_method: @shipping_method }) }
      format.html { render :show }
    end
  end

  def handle_payment_step
    shipping_address = Address.find(session[:checkout_shipping_address_id])
    shipping_method = session[:checkout_shipping_method_id] ? ShippingMethod.find(session[:checkout_shipping_method_id]) : nil
    email = session[:checkout_email]

    # Create the order
    order_result = Orders::CreateOrderService.call(
      cart: current_cart,
      email: email,
      shipping_address: shipping_address,
      billing_address: shipping_address,
      shipping_method: shipping_method,
      user: current_user,
      coupon_code: session[:checkout_coupon_code],
      gift_card_code: session[:checkout_gift_card_code]
    )

    unless order_result.success?
      @step = "payment"
      @shipping_methods = ShippingMethod.active
      flash.now[:alert] = order_result.errors.join(", ")
      render :show, status: :unprocessable_entity
      return
    end

    order = order_result.payload[:order]

    # Create Stripe Payment Intent
    payment_result = Payments::CreatePaymentIntentService.call(order: order)

    if payment_result.success?
      clear_checkout_session
      cookies.delete(:cart_token)
      # For now, mark as confirmed directly (Stripe webhook will handle in production)
      order.update!(status: :confirmed, completed_at: Time.current)
      redirect_to confirm_checkout_path(order_number: order.number)
    else
      flash.now[:alert] = payment_result.errors.join(", ")
      @step = "payment"
      @shipping_methods = ShippingMethod.active
      render :show, status: :unprocessable_entity
    end
  end

  def address_params
    params.require(:address).permit(:first_name, :last_name, :address_line_1, :address_line_2, :city, :state, :postal_code, :country_code, :phone)
  end

  def clear_checkout_session
    session.delete(:checkout_shipping_address_id)
    session.delete(:checkout_billing_address_id)
    session.delete(:checkout_shipping_method_id)
    session.delete(:checkout_email)
    session.delete(:checkout_coupon_code)
    session.delete(:checkout_coupon_error)
    session.delete(:checkout_gift_card_code)
    session.delete(:checkout_gift_card_error)
  end
end
