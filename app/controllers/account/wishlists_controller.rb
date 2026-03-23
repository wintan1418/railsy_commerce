module Account
  class WishlistsController < BaseController
    def show
      @wishlist = current_user.wishlist || current_user.create_wishlist
      @items = @wishlist.wishlist_items.includes(variant: { product: { images_attachments: :blob } })
    end

    def toggle
      wishlist = current_user.wishlist || current_user.create_wishlist
      variant = Variant.find(params[:variant_id])
      item = wishlist.wishlist_items.find_by(variant: variant)

      if item
        item.destroy
        redirect_back fallback_location: account_wishlist_path, notice: "Removed from wishlist."
      else
        wishlist.wishlist_items.create!(variant: variant)
        redirect_back fallback_location: account_wishlist_path, notice: "Added to wishlist!"
      end
    end
  end
end
