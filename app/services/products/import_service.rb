module Products
  class ImportService < ApplicationService
    def initialize(file:)
      @file = file
    end

    def call
      rows = CSV.parse(@file.read, headers: true, header_converters: :symbol)
      success_count = 0
      errors = []

      rows.each_with_index do |row, index|
        line = index + 2 # account for header
        begin
          category = row[:category].present? ? Category.find_or_create_by!(name: row[:category].strip) { |c| c.slug = row[:category].strip.parameterize } : nil
          price_cents = parse_price(row[:price])

          product = Product.create!(
            name: row[:name].to_s.strip,
            description: row[:description].to_s.strip,
            category: category,
            status: row[:status].to_s.strip.presence || "draft"
          )

          product.variants.create!(
            sku: row[:sku].to_s.strip.presence || "SKU-#{SecureRandom.alphanumeric(6).upcase}",
            price_cents: price_cents,
            is_master: true,
            position: 0
          )

          success_count += 1
        rescue => e
          errors << "Row #{line}: #{e.message}"
        end
      end

      success(success_count: success_count, error_count: errors.size, errors: errors)
    rescue CSV::MalformedCSVError => e
      failure("Invalid CSV file: #{e.message}")
    rescue => e
      failure("Import failed: #{e.message}")
    end

    private

    def parse_price(value)
      return 0 if value.blank?
      # Handle "$29.99" or "29.99" or "2999"
      cleaned = value.to_s.gsub(/[^0-9.]/, "")
      if cleaned.include?(".")
        (cleaned.to_f * 100).round
      else
        cleaned.to_i
      end
    end
  end
end
