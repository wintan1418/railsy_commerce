module Admin
  class ReviewsController < BaseController
    def index
      @reviews = Review.includes(:product, :user).recent
      @reviews = @reviews.where(status: params[:status]) if params[:status].present?
    end

    def update
      @review = Review.find(params[:id])
      @review.update!(status: params[:review][:status])

      if @review.approved?
        Notification.create!(
          user: @review.user,
          title: "Your review was approved",
          body: "Your review for #{@review.product.name} is now live.",
          notification_type: "info",
          url: "/products/#{@review.product.slug}"
        )
      end

      redirect_to admin_reviews_path, notice: "Review #{@review.status}."
    end

    def destroy
      Review.find(params[:id]).destroy
      redirect_to admin_reviews_path, notice: "Review deleted."
    end
  end
end
