require "test_helper"

module Products
  class ImportServiceTest < ActiveSupport::TestCase
    test "imports valid CSV" do
      csv = StringIO.new("name,description,category,price,sku,status\nImported Widget,A nice widget,Electronics,49.99,WDG-001,draft\n")
      result = Products::ImportService.call(file: csv)

      assert result.success?
      assert_equal 1, result.payload[:success_count]
      assert_equal 0, result.payload[:error_count]

      product = Product.find_by(name: "Imported Widget")
      assert_not_nil product
      assert_equal "draft", product.status
      assert_equal 4999, product.master_variant.price_cents
    end

    test "handles missing name" do
      csv = StringIO.new("name,description,category,price,sku,status\n,No name product,,10.00,SKU1,draft\n")
      result = Products::ImportService.call(file: csv)

      assert result.success?
      assert_equal 0, result.payload[:success_count]
      assert_equal 1, result.payload[:error_count]
    end

    test "creates category if not exists" do
      csv = StringIO.new("name,description,category,price,sku,status\nNew Cat Product,Desc,Brand New Category,29.99,BNC-001,active\n")
      result = Products::ImportService.call(file: csv)

      assert result.success?
      assert Category.exists?(name: "Brand New Category")
    end

    test "handles dollar sign in price" do
      csv = StringIO.new("name,description,category,price,sku,status\nPriced Item,Desc,,\"$99.50\",PI-001,draft\n")
      result = Products::ImportService.call(file: csv)

      assert result.success?
      product = Product.find_by(name: "Priced Item")
      assert_equal 9950, product.master_variant.price_cents
    end

    test "handles malformed CSV" do
      csv = StringIO.new("this is not,valid\ncsv\"data")
      result = Products::ImportService.call(file: csv)

      assert result.failure? || result.payload[:error_count] > 0
    end
  end
end
