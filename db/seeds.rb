puts "Seeding RailsyCommerce..."

# Users
admin = User.find_or_create_by!(email_address: "admin@railsycommerce.com") do |u|
  u.password = "password"
  u.first_name = "Admin"
  u.last_name = "User"
  u.role = :admin
end
puts "  Admin: admin@railsycommerce.com / password"

customer = User.find_or_create_by!(email_address: "customer@example.com") do |u|
  u.password = "password"
  u.first_name = "Jane"
  u.last_name = "Doe"
  u.role = :customer
end
puts "  Customer: customer@example.com / password"

# Categories
categories_data = [
  { name: "Clothing", description: "Apparel, fashion, and accessories" },
  { name: "Electronics", description: "Gadgets, devices, and tech" },
  { name: "Home & Garden", description: "Everything for your home" },
  { name: "Sports & Outdoors", description: "Active lifestyle gear" },
  { name: "Books", description: "Fiction, non-fiction, and more" }
]

categories = categories_data.map do |data|
  Category.find_or_create_by!(name: data[:name]) do |c|
    c.description = data[:description]
    c.active = true
  end
end
puts "  #{categories.count} categories created"

# Subcategories
clothing = Category.find_by!(name: "Clothing")
%w[T-Shirts Hoodies Pants Jackets].each_with_index do |name, i|
  Category.find_or_create_by!(name: name) do |c|
    c.parent = clothing
    c.position = i
    c.active = true
  end
end

electronics = Category.find_by!(name: "Electronics")
%w[Laptops Phones Headphones Accessories].each_with_index do |name, i|
  Category.find_or_create_by!(name: name) do |c|
    c.parent = electronics
    c.position = i
    c.active = true
  end
end

# Option Types
size = OptionType.find_or_create_by!(name: "size") { |ot| ot.presentation = "Size" }
color = OptionType.find_or_create_by!(name: "color") { |ot| ot.presentation = "Color" }

# Option Values
sizes = %w[XS S M L XL XXL].each_with_index.map do |name, i|
  OptionValue.find_or_create_by!(option_type: size, name: name.downcase) do |ov|
    ov.presentation = name
    ov.position = i
  end
end

colors = %w[Black White Navy Red Blue Green].each_with_index.map do |name, i|
  OptionValue.find_or_create_by!(option_type: color, name: name.downcase) do |ov|
    ov.presentation = name
    ov.position = i
  end
end

# Stock Location
warehouse = StockLocation.find_or_create_by!(name: "Main Warehouse") do |sl|
  sl.active = true
  sl.default = true
end

# Shipping Methods
ShippingMethod.find_or_create_by!(name: "Standard Shipping") do |sm|
  sm.description = "Delivered in 5-7 business days"
  sm.price_cents = 999
  sm.min_delivery_days = 5
  sm.max_delivery_days = 7
  sm.active = true
end

ShippingMethod.find_or_create_by!(name: "Express Shipping") do |sm|
  sm.description = "Delivered in 1-2 business days"
  sm.price_cents = 2499
  sm.min_delivery_days = 1
  sm.max_delivery_days = 2
  sm.active = true
end

ShippingMethod.find_or_create_by!(name: "Free Shipping") do |sm|
  sm.description = "Delivered in 7-10 business days"
  sm.price_cents = 0
  sm.min_delivery_days = 7
  sm.max_delivery_days = 10
  sm.active = true
end

# Products
products_data = [
  {
    name: "Classic Cotton T-Shirt",
    description: "A premium cotton t-shirt with a comfortable fit. Made from 100% organic cotton for breathability and softness. Available in multiple sizes and colors.",
    category: "T-Shirts",
    price: 2999,
    compare_at: 3999,
    has_options: true
  },
  {
    name: "Premium Hoodie",
    description: "Stay warm and stylish with our premium fleece-lined hoodie. Features a kangaroo pocket and adjustable drawstring hood.",
    category: "Hoodies",
    price: 5999,
    compare_at: nil,
    has_options: true
  },
  {
    name: "Slim Fit Jeans",
    description: "Modern slim fit jeans crafted from premium stretch denim. Comfortable all-day wear with a contemporary silhouette.",
    category: "Pants",
    price: 7999,
    compare_at: 9999,
    has_options: true
  },
  {
    name: "Lightweight Jacket",
    description: "A versatile lightweight jacket perfect for layering. Water-resistant shell with breathable lining.",
    category: "Jackets",
    price: 12999,
    compare_at: nil,
    has_options: false
  },
  {
    name: "Pro Laptop 15\"",
    description: "High-performance laptop with a 15-inch Retina display. Features the latest processor, 16GB RAM, and 512GB SSD storage. Perfect for professionals and creators.",
    category: "Laptops",
    price: 149900,
    compare_at: nil,
    has_options: false
  },
  {
    name: "Wireless Earbuds Pro",
    description: "Premium wireless earbuds with active noise cancellation. Up to 8 hours of battery life with the charging case extending to 32 hours total.",
    category: "Headphones",
    price: 19900,
    compare_at: 24900,
    has_options: false
  },
  {
    name: "Smart Watch Series X",
    description: "Advanced smartwatch with health monitoring, GPS, and 5-day battery life. Water resistant to 50 meters.",
    category: "Accessories",
    price: 34900,
    compare_at: nil,
    has_options: false
  },
  {
    name: "Ceramic Plant Pot Set",
    description: "Set of 3 minimalist ceramic plant pots in graduating sizes. Perfect for indoor plants and succulents.",
    category: "Home & Garden",
    price: 4999,
    compare_at: 6999,
    has_options: false
  },
  {
    name: "Yoga Mat Premium",
    description: "Extra thick 6mm yoga mat with non-slip texture. Made from eco-friendly TPE material with carrying strap included.",
    category: "Sports & Outdoors",
    price: 3999,
    compare_at: nil,
    has_options: false
  },
  {
    name: "The Art of Rails",
    description: "Master Ruby on Rails with this comprehensive guide covering everything from basics to advanced patterns. 500+ pages of practical knowledge.",
    category: "Books",
    price: 4999,
    compare_at: nil,
    has_options: false
  },
  {
    name: "USB-C Hub 7-in-1",
    description: "Expand your laptop connectivity with this compact USB-C hub featuring HDMI, USB-A, SD card reader, and ethernet port.",
    category: "Accessories",
    price: 5999,
    compare_at: 7999,
    has_options: false
  },
  {
    name: "Running Shoes Ultra",
    description: "Lightweight running shoes with responsive cushioning and breathable mesh upper. Designed for road running and daily training.",
    category: "Sports & Outdoors",
    price: 12999,
    compare_at: 15999,
    has_options: true
  }
]

products_data.each do |data|
  category = Category.find_by(name: data[:category])
  product = Product.find_or_create_by!(name: data[:name]) do |p|
    p.description = data[:description]
    p.category = category
    p.status = :active
  end

  # Create master variant
  if product.variants.empty?
    master = product.variants.create!(
      is_master: true,
      price_cents: data[:price],
      compare_at_price_cents: data[:compare_at],
      sku: "#{product.slug.upcase.tr('-', '')}-001"
    )

    # Stock for master
    StockItem.find_or_create_by!(variant: master, stock_location: warehouse) do |si|
      si.available_quantity = rand(20..200)
    end

    # Create option variants for clothing items
    if data[:has_options]
      product.product_option_types.find_or_create_by!(option_type: size)

      selected_sizes = sizes.sample(4).sort_by(&:position)
      selected_sizes.each_with_index do |size_val, i|
        variant = product.variants.create!(
          is_master: false,
          price_cents: data[:price],
          compare_at_price_cents: data[:compare_at],
          sku: "#{product.slug.upcase.tr('-', '')}-#{size_val.name.upcase}",
          position: i + 1
        )
        variant.option_values << size_val

        StockItem.find_or_create_by!(variant: variant, stock_location: warehouse) do |si|
          si.available_quantity = rand(10..100)
        end
      end
    end
  end
end
puts "  #{Product.count} products created"

# Sample orders
address = Address.find_or_create_by!(user: customer, address_line_1: "123 Main St") do |a|
  a.first_name = "Jane"
  a.last_name = "Doe"
  a.city = "New York"
  a.state = "NY"
  a.postal_code = "10001"
  a.country_code = "US"
  a.phone = "555-0100"
end

if Order.count == 0
  5.times do |i|
    order = Order.create!(
      user: customer,
      email: customer.email_address,
      shipping_address: address,
      billing_address: address,
      status: %w[pending confirmed processing shipped delivered].sample,
      subtotal_cents: rand(2999..20000),
      shipping_total_cents: [ 0, 999, 2499 ].sample,
      tax_total_cents: rand(200..1600),
      currency: "USD"
    )
    order.recalculate_totals!

    # Add 1-3 items
    variants = Variant.where(is_master: true).sample(rand(1..3))
    variants.each do |variant|
      qty = rand(1..3)
      order.order_items.create!(
        variant: variant,
        quantity: qty,
        unit_price_cents: variant.price_cents,
        total_cents: variant.price_cents * qty
      )
    end
    order.recalculate_totals!
  end
  puts "  #{Order.count} sample orders created"
end

puts "Seeding complete!"
