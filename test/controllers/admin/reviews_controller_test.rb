require "test_helper"

module Admin
  class ReviewsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists reviews" do
      get admin_reviews_url
      assert_response :success
    end

    test "approve review" do
      patch admin_review_url(reviews(:pending_review)), params: {
        review: { status: "approved" }
      }
      assert_redirected_to admin_reviews_url
      assert_equal "approved", reviews(:pending_review).reload.status
    end

    test "delete review" do
      assert_difference "Review.count", -1 do
        delete admin_review_url(reviews(:pending_review))
      end
    end
  end
end
