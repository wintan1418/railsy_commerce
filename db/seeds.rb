require "open-uri"

puts "Seeding RailsyCommerce..."

# ─── Users ──────────────────────────────────────────────────────────
admin = User.find_or_create_by!(email_address: "admin@railsycommerce.com") do |u|
  u.password = "password"
  u.first_name = "Admin"
  u.last_name = "User"
  u.role = :admin
end
puts "  Admin: admin@railsycommerce.com / password"

customers_data = [
  { email: "jane.doe@example.com", first: "Jane", last: "Doe" },
  { email: "john.smith@example.com", first: "John", last: "Smith" },
  { email: "sarah.chen@example.com", first: "Sarah", last: "Chen" },
  { email: "marcus.johnson@example.com", first: "Marcus", last: "Johnson" },
  { email: "emily.williams@example.com", first: "Emily", last: "Williams" },
  { email: "david.brown@example.com", first: "David", last: "Brown" },
  { email: "lisa.martinez@example.com", first: "Lisa", last: "Martinez" },
  { email: "customer@example.com", first: "Alex", last: "Taylor" }
]

customers = customers_data.map do |data|
  User.find_or_create_by!(email_address: data[:email]) do |u|
    u.password = "password"
    u.first_name = data[:first]
    u.last_name = data[:last]
    u.role = :customer
  end
end
puts "  #{customers.count} customers created"

# ─── Categories (roots) ────────────────────────────────────────────
root_categories_data = [
  { name: "Clothing", description: "Premium apparel and fashion essentials for every occasion" },
  { name: "Electronics", description: "Cutting-edge gadgets, devices, and tech accessories" },
  { name: "Home & Living", description: "Curated home decor, furniture, and lifestyle products" },
  { name: "Sports & Outdoors", description: "Performance gear for active lifestyles" },
  { name: "Accessories", description: "Bags, watches, jewelry, and finishing touches" },
  { name: "Beauty & Wellness", description: "Skincare, grooming, and wellness essentials" }
]

root_categories = root_categories_data.each_with_index.map do |data, i|
  Category.find_or_create_by!(name: data[:name]) do |c|
    c.description = data[:description]
    c.position = i
    c.active = true
  end
end
puts "  #{root_categories.count} root categories created"

# ─── Subcategories ─────────────────────────────────────────────────
subcategories_map = {
  "Clothing" => ["T-Shirts", "Hoodies & Sweaters", "Pants & Jeans", "Jackets & Coats", "Dresses", "Activewear"],
  "Electronics" => ["Laptops", "Smartphones", "Headphones & Audio", "Wearables", "Cameras"],
  "Home & Living" => ["Decor", "Kitchen", "Bedding", "Lighting", "Plants & Garden"],
  "Sports & Outdoors" => ["Running", "Yoga & Fitness", "Hiking & Camping", "Cycling", "Swimming"],
  "Accessories" => ["Bags & Backpacks", "Watches", "Sunglasses", "Jewelry", "Hats & Scarves"],
  "Beauty & Wellness" => ["Skincare", "Fragrances", "Hair Care", "Supplements"]
}

subcategories_map.each do |parent_name, children|
  parent = Category.find_by!(name: parent_name)
  children.each_with_index do |name, i|
    Category.find_or_create_by!(name: name) do |c|
      c.parent = parent
      c.position = i
      c.active = true
    end
  end
end
puts "  Subcategories created"

# ─── Option Types & Values ─────────────────────────────────────────
size_type = OptionType.find_or_create_by!(name: "size") { |ot| ot.presentation = "Size" }
color_type = OptionType.find_or_create_by!(name: "color") { |ot| ot.presentation = "Color" }

sizes = %w[XS S M L XL XXL].each_with_index.map do |name, i|
  OptionValue.find_or_create_by!(option_type: size_type, name: name.downcase) do |ov|
    ov.presentation = name
    ov.position = i
  end
end

color_names = %w[Black White Navy Red Blue Green Olive Burgundy Charcoal Sand]
colors = color_names.each_with_index.map do |name, i|
  OptionValue.find_or_create_by!(option_type: color_type, name: name.downcase) do |ov|
    ov.presentation = name
    ov.position = i
  end
end

# ─── Stock Location ────────────────────────────────────────────────
warehouse = StockLocation.find_or_create_by!(name: "Main Warehouse") do |sl|
  sl.active = true
  sl.default = true
end

# ─── Shipping Methods ──────────────────────────────────────────────
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

# ─── Helper: Attach image from URL ────────────────────────────────
def attach_product_image(product, url, index = 1)
  # Skip if product already has enough images
  return if product.images.attached? && product.images.count >= index

  begin
    image = URI.open(url)
    product.images.attach(
      io: image,
      filename: "#{product.slug}-#{index}.jpg",
      content_type: "image/jpeg"
    )
    puts "    Attached image #{index} for #{product.name}"
  rescue => e
    puts "    Could not attach image #{index} for #{product.name}: #{e.message}"
  end
end

# ─── Products ──────────────────────────────────────────────────────
products_data = [
  # ── Clothing: T-Shirts ──
  {
    name: "Essential Cotton Crew Tee",
    description: "Crafted from 100% organic Pima cotton, this essential crew neck t-shirt offers an incredibly soft hand feel and a relaxed yet refined silhouette. Pre-washed for zero shrinkage. Reinforced collar and double-stitched hems ensure lasting wear. A wardrobe foundation piece.",
    category: "T-Shirts",
    price: 3900,
    compare_at: 5500,
    image_url: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80&fit=crop&crop=center",
    has_sizes: true,
    has_colors: true
  },
  {
    name: "Merino Wool V-Neck Tee",
    description: "Lightweight 150gsm merino wool blended with organic cotton for a breathable, temperature-regulating tee. Naturally odor-resistant and moisture-wicking. Perfect for travel and layering. Slim fit with a modern V-neck cut.",
    category: "T-Shirts",
    price: 6800,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=800&q=80&fit=crop&crop=top",
    has_sizes: true,
    has_colors: true
  },
  # ── Clothing: Hoodies & Sweaters ──
  {
    name: "Heavyweight French Terry Hoodie",
    description: "A premium 400gsm French terry hoodie with a relaxed oversized fit. Features a lined kangaroo pocket, brushed interior, and YKK zipper at the collar. Raglan sleeves for unrestricted movement. The kind of hoodie you reach for every day.",
    category: "Hoodies & Sweaters",
    price: 8900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&q=80&fit=crop&crop=center",
    has_sizes: true,
    has_colors: true
  },
  {
    name: "Cashmere Blend Crewneck Sweater",
    description: "Luxuriously soft cashmere-wool blend knit in a classic crewneck silhouette. 7-gauge knit with ribbed cuffs and hem. Minimal branding for a clean, versatile look that pairs with everything from jeans to tailored trousers.",
    category: "Hoodies & Sweaters",
    price: 14900,
    compare_at: 18900,
    image_url: "https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&q=80&fit=crop&crop=top",
    has_sizes: true,
    has_colors: true
  },
  # ── Clothing: Pants & Jeans ──
  {
    name: "Selvedge Slim Fit Denim",
    description: "14oz Japanese selvedge denim with a modern slim taper. Raw indigo with natural fading potential. Five-pocket construction with copper rivets and YKK brass zipper. Chain-stitched hem. Will develop unique character with every wear.",
    category: "Pants & Jeans",
    price: 12900,
    compare_at: 16500,
    image_url: "https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&q=80&fit=crop&crop=bottom",
    has_sizes: true,
    has_colors: false
  },
  {
    name: "Tailored Chino Pants",
    description: "Garment-dyed stretch cotton chinos with a tailored fit through the thigh and a slight taper to the ankle. Features a hook-and-bar closure, French fly, and rear welt pockets. Perfect for smart-casual occasions.",
    category: "Pants & Jeans",
    price: 8900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&q=80&fit=crop&crop=center",
    has_sizes: true,
    has_colors: true
  },
  # ── Clothing: Jackets ──
  {
    name: "Water-Resistant Field Jacket",
    description: "A modern take on the military field jacket. DWR-coated cotton-nylon shell with a warm quilted lining. Four flap pockets, internal media pocket, and adjustable drawcord waist. Ideal for transitional weather.",
    category: "Jackets & Coats",
    price: 22900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&q=80&fit=crop&crop=top",
    has_sizes: true,
    has_colors: false
  },
  # ── Electronics: Laptops ──
  {
    name: "ProBook Ultra 15\" Laptop",
    description: "Powerhouse performance in a slim aluminum chassis. Features a 15.6\" 3K OLED display, latest-gen processor, 32GB unified memory, and 1TB NVMe SSD. Thunderbolt 4 ports, Wi-Fi 7, and 18-hour battery life. Built for creators and professionals.",
    category: "Laptops",
    price: 189900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  # ── Electronics: Headphones ──
  {
    name: "AeroSound Pro Wireless Headphones",
    description: "Immersive listening with hybrid active noise cancellation and spatial audio. 40mm custom drivers deliver studio-quality sound. 30-hour battery life, multipoint Bluetooth 5.3 connection, and ultra-comfortable memory foam ear cushions.",
    category: "Headphones & Audio",
    price: 29900,
    compare_at: 34900,
    image_url: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Studio Monitor Earbuds",
    description: "True wireless earbuds engineered for audiophiles. Dual balanced-armature drivers with a dynamic driver for deep bass. ANC with transparency mode, wireless charging case, and IPX5 water resistance. 8 hours playback, 32 hours total with case.",
    category: "Headphones & Audio",
    price: 19900,
    compare_at: 24900,
    image_url: "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  # ── Electronics: Wearables ──
  {
    name: "Apex Smart Watch Series 5",
    description: "Your comprehensive health and fitness companion. Always-on AMOLED display, advanced heart rate and SpO2 monitoring, built-in GPS, and 7-day battery life. 100+ workout modes, sleep tracking, and stress management tools. 5ATM water resistance.",
    category: "Wearables",
    price: 39900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  # ── Electronics: Cameras ──
  {
    name: "Mirrorless Camera Kit 28mm",
    description: "Compact full-frame mirrorless camera with a 28mm f/2.0 prime lens. 45MP sensor, 5-axis IBIS, 4K 120fps video capability, and dual card slots. Weather-sealed magnesium alloy body. Perfect for street photography and travel.",
    category: "Cameras",
    price: 249900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  # ── Home & Living ──
  {
    name: "Artisan Ceramic Vase Set",
    description: "Set of three hand-thrown ceramic vases in graduating sizes. Matte glaze finish in earthy tones. Each piece is unique with subtle variations. Perfect for dried botanicals or as sculptural accents. Tallest vase stands at 14 inches.",
    category: "Decor",
    price: 7900,
    compare_at: 9900,
    image_url: "https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Linen Blend Throw Blanket",
    description: "Woven from a luxurious linen-cotton blend, this throw adds texture and warmth to any space. Fringe edge detail and subtle heathered pattern. 50\" x 70\". Machine washable and gets softer with every wash.",
    category: "Bedding",
    price: 8900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Pour-Over Coffee Set",
    description: "Complete pour-over coffee brewing set including a hand-blown borosilicate glass carafe, reusable stainless steel filter, and walnut wood collar with leather tie. Brews 4 cups. A ritual worth savoring.",
    category: "Kitchen",
    price: 6400,
    compare_at: 7900,
    image_url: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Sculptural Table Lamp",
    description: "A statement lighting piece with an organic sculptural base in brushed brass and a linen drum shade. 18 inches tall. Dimmable with a touch sensor. Creates warm ambient lighting for living rooms and bedrooms.",
    category: "Lighting",
    price: 14900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  # ── Sports & Outdoors ──
  {
    name: "Carbon Plate Running Shoes",
    description: "Elite performance running shoes with a full-length carbon fiber plate and nitrogen-infused foam midsole. Engineered mesh upper provides targeted breathability and lockdown fit. 7.8oz for men's size 10. Built for race day and speed sessions.",
    category: "Running",
    price: 17900,
    compare_at: 21900,
    image_url: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80&fit=crop&crop=center",
    has_sizes: true,
    has_colors: false
  },
  {
    name: "Performance Yoga Mat 6mm",
    description: "Professional-grade yoga mat with a dual-texture surface: microfiber top for grip and natural rubber base for cushioning. 6mm thick, 72\" x 26\". Includes carrying strap. Free from PVC, latex, and toxic chemicals.",
    category: "Yoga & Fitness",
    price: 7900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Ultralight Down Jacket",
    description: "Packable 800-fill power goose down jacket weighing just 10oz. Water-resistant Pertex Quantum shell with welded baffles to prevent cold spots. Stuff sack included. Perfect as a standalone piece or mid-layer.",
    category: "Hiking & Camping",
    price: 19900,
    compare_at: 24900,
    image_url: "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&q=80&fit=crop&crop=top",
    has_sizes: true,
    has_colors: true
  },
  # ── Accessories ──
  {
    name: "Heritage Leather Tote",
    description: "Full-grain vegetable-tanned leather tote bag with brass hardware. Unlined interior with one zip pocket and two slip pockets. Reinforced handles and riveted stress points. Develops a beautiful patina over time. 14\" x 12\" x 5\".",
    category: "Bags & Backpacks",
    price: 24900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Titanium Chronograph Watch",
    description: "Swiss automatic movement housed in a grade-2 titanium case. Sapphire crystal with anti-reflective coating. Water resistant to 100m. 42mm case diameter with a quick-release Italian leather strap. Minimal dial with applied indices.",
    category: "Watches",
    price: 49900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Polarized Aviator Sunglasses",
    description: "Classic aviator frame in lightweight titanium with polarized CR-39 lenses providing 100% UV protection. Spring hinges for a comfortable fit. Includes a leather hard case and microfiber cleaning cloth. Lens width 58mm.",
    category: "Sunglasses",
    price: 16900,
    compare_at: 19900,
    image_url: "https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  # ── Beauty & Wellness ──
  {
    name: "Botanical Face Serum",
    description: "Concentrated face serum with hyaluronic acid, vitamin C, and botanical extracts. Lightweight, fast-absorbing formula hydrates and brightens skin. Dermatologist tested. Free from parabens, sulfates, and synthetic fragrances. 1 fl oz.",
    category: "Skincare",
    price: 5400,
    compare_at: 6800,
    image_url: "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Eau de Parfum - Coastal Cedar",
    description: "An evocative fragrance built on Virginia cedar and sea salt, layered with bergamot, ambrette seed, and driftwood accord. Long-lasting sillage with a natural, unforced character. 50ml glass bottle with wooden cap.",
    category: "Fragrances",
    price: 9800,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1541643600914-78b084683601?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1541643600914-78b084683601?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Daily Wellness Capsules",
    description: "Comprehensive daily multivitamin with adaptogens, probiotics, and omega-3s. Third-party tested for purity and potency. Plant-based capsules with no fillers or artificial ingredients. 60-day supply.",
    category: "Supplements",
    price: 3900,
    compare_at: 4900,
    image_url: "https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  }
]

products_data.each_with_index do |data, idx|
  category = Category.find_by(name: data[:category])
  product = Product.find_or_create_by!(name: data[:name]) do |p|
    p.description = data[:description]
    p.category = category
    p.status = :active
  end

  if product.variants.empty?
    master = product.variants.create!(
      is_master: true,
      price_cents: data[:price],
      compare_at_price_cents: data[:compare_at],
      sku: "RC-#{(idx + 1).to_s.rjust(4, '0')}-MST"
    )

    StockItem.find_or_create_by!(variant: master, stock_location: warehouse) do |si|
      si.available_quantity = rand(15..300)
    end

    # Size variants for clothing items
    if data[:has_sizes]
      product.product_option_types.find_or_create_by!(option_type: size_type)

      selected_sizes = sizes.sample(rand(4..6)).sort_by(&:position)
      selected_sizes.each_with_index do |size_val, i|
        sku = "RC-#{(idx + 1).to_s.rjust(4, '0')}-#{size_val.name.upcase}"

        # If also has colors, create size+color combos
        if data[:has_colors]
          product.product_option_types.find_or_create_by!(option_type: color_type)
          selected_colors = colors.sample(rand(3..5)).sort_by(&:position)

          selected_colors.each_with_index do |color_val, j|
            variant_sku = "#{sku}-#{color_val.name.upcase[0..2]}"
            variant = product.variants.create!(
              is_master: false,
              price_cents: data[:price],
              compare_at_price_cents: data[:compare_at],
              sku: variant_sku,
              position: (i * selected_colors.length) + j + 1
            )
            variant.option_values << size_val
            variant.option_values << color_val

            StockItem.find_or_create_by!(variant: variant, stock_location: warehouse) do |si|
              si.available_quantity = rand(5..80)
            end
          end
        else
          variant = product.variants.create!(
            is_master: false,
            price_cents: data[:price],
            compare_at_price_cents: data[:compare_at],
            sku: sku,
            position: i + 1
          )
          variant.option_values << size_val

          StockItem.find_or_create_by!(variant: variant, stock_location: warehouse) do |si|
            si.available_quantity = rand(5..80)
          end
        end
      end
    end
  end

  # Attach product images (2 per product for gallery)
  attach_product_image(product, data[:image_url], 1)
  attach_product_image(product, data[:image_url_alt], 2)
end
puts "  #{Product.count} products created"

# ─── Sample Addresses ──────────────────────────────────────────────
addresses_data = [
  { user: customers[0], line1: "123 Main Street", city: "New York", state: "NY", zip: "10001", phone: "555-0100" },
  { user: customers[1], line1: "456 Oak Avenue", city: "Los Angeles", state: "CA", zip: "90001", phone: "555-0200" },
  { user: customers[2], line1: "789 Pine Road", city: "San Francisco", state: "CA", zip: "94102", phone: "555-0300" },
  { user: customers[3], line1: "321 Elm Street", city: "Chicago", state: "IL", zip: "60601", phone: "555-0400" },
  { user: customers[4], line1: "654 Maple Drive", city: "Austin", state: "TX", zip: "73301", phone: "555-0500" },
  { user: customers[5], line1: "987 Cedar Lane", city: "Seattle", state: "WA", zip: "98101", phone: "555-0600" },
  { user: customers[6], line1: "159 Birch Court", city: "Miami", state: "FL", zip: "33101", phone: "555-0700" },
  { user: customers[7], line1: "753 Walnut Way", city: "Denver", state: "CO", zip: "80201", phone: "555-0800" }
]

addresses = addresses_data.map do |data|
  Address.find_or_create_by!(user: data[:user], address_line_1: data[:line1]) do |a|
    a.first_name = data[:user].first_name
    a.last_name = data[:user].last_name
    a.city = data[:city]
    a.state = data[:state]
    a.postal_code = data[:zip]
    a.country_code = "US"
    a.phone = data[:phone]
  end
end

# ─── Sample Orders ─────────────────────────────────────────────────
if Order.count == 0
  statuses = %w[pending confirmed processing shipped delivered delivered delivered]
  master_variants = Variant.where(is_master: true).to_a

  12.times do |i|
    customer = customers.sample
    address = addresses.detect { |a| a.user_id == customer.id } || addresses.first

    order = Order.create!(
      user: customer,
      email: customer.email_address,
      shipping_address: address,
      billing_address: address,
      status: statuses.sample,
      subtotal_cents: 0,
      shipping_total_cents: [0, 999, 2499].sample,
      tax_total_cents: 0,
      currency: "USD",
      created_at: rand(30).days.ago
    )

    # Add 1-4 items
    selected_variants = master_variants.sample(rand(1..4))
    selected_variants.each do |variant|
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

puts ""
puts "Seeding complete!"
puts "  Products: #{Product.count}"
puts "  Categories: #{Category.count} (#{Category.roots.count} root)"
puts "  Variants: #{Variant.count}"
puts "  Orders: #{Order.count}"
puts "  Users: #{User.count} (#{User.customer.count} customers)"
