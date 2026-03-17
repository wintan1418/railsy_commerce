require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "valid review" do
    review = reviews(:approved_review)
    assert review.valid?
    assert review.approved?
  end

  test "requires rating between 1-5" do
    review = Review.new(product: products(:tshirt), user: users(:admin), rating: 0)
    assert_not review.valid?
    review.rating = 6
    assert_not review.valid?
    review.rating = 3
    assert review.valid?
  end

  test "one review per user per product" do
    review = Review.new(product: products(:tshirt), user: users(:customer), rating: 3)
    assert_not review.valid?
    assert_includes review.errors[:user_id], "has already reviewed this product"
  end

  test "approved scope" do
    approved = Review.approved
    assert_includes approved, reviews(:approved_review)
    assert_not_includes approved, reviews(:pending_review)
  end
end
