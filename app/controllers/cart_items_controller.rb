class CartItemsController < ApplicationController
  include CartManagement
  allow_unauthenticated_access

  def create
    variant = Variant.find(params[:variant_id])
    result = Carts::AddItemService.call(
      cart: current_cart,
      variant: variant,
      quantity: params[:quantity] || 1
    )

    if result.success?
      redirect_back fallback_location: products_path, notice: "Added to cart!"
    else
      redirect_back fallback_location: products_path, alert: result.errors.join(", ")
    end
  end

  def update
    @cart_item = current_cart.cart_items.find(params[:id])

    if @cart_item.update(quantity: params[:cart_item][:quantity].to_i)
      redirect_to cart_path, notice: "Cart updated."
    else
      redirect_to cart_path, alert: "Could not update quantity."
    end
  end

  def destroy
    @cart_item = current_cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: "Item removed."
  end
end
