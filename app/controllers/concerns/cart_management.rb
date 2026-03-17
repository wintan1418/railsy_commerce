module CartManagement
  extend ActiveSupport::Concern

  included do
    helper_method :current_cart
  end

  private

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    if (token = cookies.signed[:cart_token])
      cart = Cart.active.find_by(token: token)
    end

    if cart.nil?
      cart = Cart.create!(user: current_user)
      cookies.signed.permanent[:cart_token] = { value: cart.token, httponly: true, same_site: :lax }
    end

    # Link cart to user if they just logged in
    if current_user && cart.user_id.nil?
      cart.update!(user: current_user)
    end

    cart
  end
end
