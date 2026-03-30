class CartMailer < ApplicationMailer
  def abandoned(cart)
    @cart = cart
    @user = cart.user
    @cart_items = cart.cart_items.includes(variant: { product: { images_attachments: :blob } })

    return unless @user&.email_address.present?

    mail(
      to: @user.email_address,
      subject: "You left items in your cart!"
    )
  end
end
