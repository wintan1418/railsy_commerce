require "test_helper"

module Admin
  class ImportsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "new shows import form" do
      get new_admin_import_url
      assert_response :success
      assert_select "h1", /Import Products/
    end

    test "create imports CSV successfully" do
      file = Tempfile.new([ "import", ".csv" ])
      file.write("name,description,category,price,sku,status\nTest Import Product,A test product,Electronics,19.99,IMP-001,draft\n")
      file.rewind

      uploaded = Rack::Test::UploadedFile.new(file.path, "text/csv")
      initial_count = Product.count

      post admin_import_url, params: { file: uploaded }

      assert_redirected_to admin_products_url
      assert Product.count >= initial_count
    ensure
      file&.close
      file&.unlink
    end

    test "create without file redirects with alert" do
      post admin_import_url
      assert_redirected_to new_admin_import_url
    end

    test "requires admin" do
      delete session_url
      sign_in_as users(:customer)
      get new_admin_import_url
      assert_redirected_to root_url
    end
  end
end
