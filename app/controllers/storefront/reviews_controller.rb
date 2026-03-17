module Storefront
  class ReviewsController < ApplicationController
    include CartManagement

    def create
      @product = Product.friendly.find(params[:product_id])
      @review = @product.reviews.build(review_params)
      @review.user = current_user

      if @review.save
        redirect_to product_path(@product), notice: "Review submitted for moderation."
      else
        redirect_to product_path(@product), alert: @review.errors.full_messages.join(", ")
      end
    end

    private

    def review_params
      params.require(:review).permit(:rating, :title, :body)
    end
  end
end
