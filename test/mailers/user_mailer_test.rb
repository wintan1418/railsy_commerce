require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome email" do
    user = users(:customer)
    email = UserMailer.welcome(user)

    assert_equal [ user.email_address ], email.to
    assert_includes email.subject, "Welcome"
  end
end
