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
  { email: "customer@example.com", first: "Alex", last: "Taylor" },
  { email: "olivia.garcia@example.com", first: "Olivia", last: "Garcia" },
  { email: "james.wilson@example.com", first: "James", last: "Wilson" },
  { email: "sophia.lee@example.com", first: "Sophia", last: "Lee" },
  { email: "daniel.kim@example.com", first: "Daniel", last: "Kim" }
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
  { name: "Fashion & Clothing", description: "Premium apparel and fashion essentials for every occasion" },
  { name: "Electronics", description: "Cutting-edge gadgets, devices, and tech accessories" },
  { name: "Home & Kitchen", description: "Cookware, furniture, bedding, lighting, and organization" },
  { name: "Sports & Fitness", description: "Performance gear for active lifestyles" },
  { name: "Accessories", description: "Bags, watches, jewelry, and finishing touches" },
  { name: "Beauty & Wellness", description: "Skincare, grooming, and wellness essentials" },
  { name: "Food & Groceries", description: "Fresh produce, snacks, beverages, and pantry staples" },
  { name: "Restaurant & Meals", description: "Gourmet meal kits and premium dining experiences at home" },
  { name: "Drinks", description: "Wine, craft beer, spirits, and refreshing beverages" },
  { name: "Baby & Kids", description: "Everything for your little ones from clothing to education" },
  { name: "Pet Supplies", description: "Premium food, toys, and accessories for your furry friends" },
  { name: "Books & Stationery", description: "Fiction, non-fiction, journals, and creative supplies" },
  { name: "Automotive", description: "Car accessories, care products, and tools for every driver" },
  { name: "Solar & Renewable Energy", description: "Solar panels, batteries, inverters, and green energy solutions" },
  { name: "Gaming", description: "Consoles, PC gaming gear, and gaming accessories" }
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
  "Fashion & Clothing" => ["T-Shirts", "Hoodies & Sweaters", "Pants & Jeans", "Jackets & Coats", "Dresses", "Activewear"],
  "Electronics" => ["Laptops", "Smartphones", "Headphones & Audio", "Wearables", "Cameras"],
  "Home & Kitchen" => ["Cookware", "Furniture", "Bedding", "Lighting", "Organization"],
  "Sports & Fitness" => ["Running", "Yoga & Fitness", "Hiking & Camping", "Cycling"],
  "Accessories" => ["Bags & Backpacks", "Watches", "Sunglasses", "Jewelry"],
  "Beauty & Wellness" => ["Skincare", "Fragrances", "Hair Care", "Supplements"],
  "Food & Groceries" => ["Fresh Produce", "Snacks", "Beverages", "Pantry Essentials"],
  "Restaurant & Meals" => ["Pizza", "Burgers", "Sushi", "Desserts", "Coffee & Tea"],
  "Drinks" => ["Wine", "Craft Beer", "Spirits", "Smoothies & Juice"],
  "Baby & Kids" => ["Baby Clothing", "Toys", "Baby Care", "Kids Education"],
  "Pet Supplies" => ["Dogs", "Cats", "Fish & Aquarium"],
  "Books & Stationery" => ["Fiction", "Non-Fiction", "Journals", "Art Supplies"],
  "Automotive" => ["Car Accessories", "Car Care", "Tools"],
  "Solar & Renewable Energy" => ["Solar Panels", "Lithium Batteries", "Tubular Batteries", "Inverters", "Solar Accessories", "Installation Services"],
  "Gaming" => ["Consoles", "PC Gaming", "Gaming Accessories"]
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
  # ══════════════════════════════════════════════════════════════════
  # FASHION & CLOTHING
  # ══════════════════════════════════════════════════════════════════

  # ── T-Shirts ──
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

  # ── Hoodies & Sweaters ──
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

  # ── Pants & Jeans ──
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

  # ── Jackets & Coats ──
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

  # ── Dresses ──
  {
    name: "Summer Floral Dress",
    description: "Light and breezy floral print dress perfect for warm-weather occasions. Features a flattering A-line silhouette with adjustable spaghetti straps and a smocked bodice. Midi length with a flowing skirt that moves beautifully.",
    category: "Dresses",
    price: 6900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&q=80&fit=crop&crop=center",
    has_sizes: true,
    has_colors: true
  },

  # ── Additional Fashion ──
  {
    name: "Leather Belt",
    description: "Full-grain Italian leather belt with a classic brushed nickel buckle. 1.25 inches wide with beveled edges and contrast stitching. Ages beautifully and pairs with both casual and dress outfits.",
    category: "Jewelry",
    price: 4900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Ankle Boots",
    description: "Sleek Chelsea-style ankle boots in premium suede with elastic side panels for easy on and off. Stacked leather heel and rubber outsole for all-day comfort. Pairs perfectly with jeans, dresses, or skirts.",
    category: "Activewear",
    price: 13900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80&fit=crop&crop=center",
    has_sizes: true,
    has_colors: false
  },
  {
    name: "Wool Beanie",
    description: "Soft ribbed merino wool beanie with a classic fold-over cuff. Warm yet breathable, perfect for chilly mornings. One size fits most with a comfortable stretch fit.",
    category: "Hoodies & Sweaters",
    price: 2900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: true
  },
  {
    name: "Silk Scarf",
    description: "Luxurious 100% mulberry silk scarf with a vibrant abstract print. Lightweight and versatile, wear it as a neck scarf, headband, or bag accessory. Hand-rolled edges for a refined finish. 35 x 35 inches.",
    category: "Dresses",
    price: 5900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1601924994987-69e26d50dc64?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1601924994987-69e26d50dc64?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # ELECTRONICS
  # ══════════════════════════════════════════════════════════════════

  # ── Laptops ──
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

  # ── Headphones & Audio ──
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

  # ── Wearables ──
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

  # ── Cameras ──
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

  # ── New Electronics ──
  {
    name: "Bluetooth Speaker",
    description: "Portable waterproof Bluetooth speaker with 360-degree sound and deep bass radiator. IPX7 rated for pool and beach use. 20-hour battery life with USB-C fast charging. Pairs two speakers for true stereo sound.",
    category: "Headphones & Audio",
    price: 7900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Wireless Charger",
    description: "Sleek 15W Qi-certified wireless charging pad with built-in cooling fan. Compatible with all Qi-enabled devices. LED indicator and foreign object detection for safe charging. Includes USB-C cable.",
    category: "Smartphones",
    price: 3900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1586816879360-004f5b0c51e5?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1586816879360-004f5b0c51e5?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Gaming Mouse",
    description: "High-performance wireless gaming mouse with 25,600 DPI optical sensor and sub-1ms click latency. 6 programmable buttons, customizable RGB lighting, and 70-hour battery life. Lightweight at just 63 grams.",
    category: "Wearables",
    price: 6900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1527814050087-3793815479db?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1527814050087-3793815479db?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Mechanical Keyboard",
    description: "Premium hot-swappable mechanical keyboard with gasket-mount construction for a satisfying typing feel. PBT double-shot keycaps, per-key RGB, and wireless tri-mode connectivity. Includes sound-dampening foam layers.",
    category: "Laptops",
    price: 12900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1595225476474-87563907a212?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1595225476474-87563907a212?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Portable SSD 1TB",
    description: "Ultra-fast 1TB portable SSD with read speeds up to 2,000 MB/s via USB 3.2 Gen 2x2. Pocket-sized aluminum enclosure with IP65 dust and water resistance. Hardware encryption for data security. Compatible with PC, Mac, and gaming consoles.",
    category: "Laptops",
    price: 8900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1531492746076-161ca9bcad58?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1531492746076-161ca9bcad58?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # HOME & KITCHEN
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Artisan Ceramic Vase Set",
    description: "Set of three hand-thrown ceramic vases in graduating sizes. Matte glaze finish in earthy tones. Each piece is unique with subtle variations. Perfect for dried botanicals or as sculptural accents. Tallest vase stands at 14 inches.",
    category: "Organization",
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
    category: "Cookware",
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
  {
    name: "Cast Iron Skillet",
    description: "Pre-seasoned 12-inch cast iron skillet with a smooth cooking surface. Superior heat retention and even distribution for perfect sears. Dual pour spouts and helper handle. Oven safe to 500 degrees. Lasts generations with proper care.",
    category: "Cookware",
    price: 4900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1585515320310-259814833e62?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1585515320310-259814833e62?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Bamboo Cutting Board Set",
    description: "Set of three premium bamboo cutting boards in small, medium, and large sizes. Knife-friendly surface with juice grooves to keep counters clean. Antimicrobial properties and sustainably sourced bamboo.",
    category: "Cookware",
    price: 3400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Memory Foam Pillow",
    description: "Cooling gel-infused memory foam pillow with adjustable loft. Removable bamboo-derived cover is hypoallergenic and machine washable. Contoured design supports proper neck alignment for side, back, and stomach sleepers.",
    category: "Bedding",
    price: 5900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Turkish Cotton Towel Set",
    description: "Set of six premium Turkish cotton towels: 2 bath, 2 hand, and 2 washcloths. 700 GSM weight for exceptional absorbency and plush softness. Quick-drying and gets softer with every wash. OEKO-TEX certified.",
    category: "Bedding",
    price: 4400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1616627561950-9f746e330187?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1616627561950-9f746e330187?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Smart LED Bulb Pack",
    description: "Pack of 4 Wi-Fi enabled smart LED bulbs with 16 million color options and tunable white. Works with Alexa, Google Home, and Apple HomeKit. Schedule automations, set scenes, and control from anywhere. 800 lumens, 9W energy efficient.",
    category: "Lighting",
    price: 2900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # SPORTS & FITNESS
  # ══════════════════════════════════════════════════════════════════

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
  {
    name: "Resistance Band Set",
    description: "Complete set of 5 resistance bands with varying tension levels from 10-50 lbs. Durable natural latex with reinforced seams. Includes door anchor, ankle straps, and carrying bag. Perfect for home workouts and physical therapy.",
    category: "Yoga & Fitness",
    price: 2400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1598289431512-b97b0917affc?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1598289431512-b97b0917affc?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Adjustable Dumbbell Set",
    description: "Space-saving adjustable dumbbells from 5 to 52.5 lbs each with a quick-change dial system. Replaces 15 sets of weights. Durable steel construction with soft-grip handles. Includes storage tray for clean organization.",
    category: "Yoga & Fitness",
    price: 19900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Protein Shaker Bottle",
    description: "BPA-free 28oz protein shaker with patented mixing system for lump-free shakes. Leak-proof snap lid with carry loop. Dishwasher safe and odor resistant. Includes pill organizer and powder storage compartments.",
    category: "Running",
    price: 1900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1593095948071-474c5cc2c1cf?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1593095948071-474c5cc2c1cf?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Jump Rope Pro",
    description: "Weighted speed jump rope with ball-bearing handles for smooth rotation. Adjustable 10ft steel cable with PVC coating. Comfortable foam-grip handles with built-in rep counter. Great for HIIT, boxing training, and cardio.",
    category: "Yoga & Fitness",
    price: 1400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1517344884509-a0c97ec11bcc?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1517344884509-a0c97ec11bcc?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # ACCESSORIES
  # ══════════════════════════════════════════════════════════════════

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

  # ══════════════════════════════════════════════════════════════════
  # BEAUTY & WELLNESS
  # ══════════════════════════════════════════════════════════════════

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
  },
  {
    name: "Moisturizing Face Cream",
    description: "Rich yet non-greasy daily moisturizer with shea butter, ceramides, and niacinamide. Strengthens the skin barrier while providing 72-hour hydration. Fragrance-free and suitable for sensitive skin. 1.7 oz jar.",
    category: "Skincare",
    price: 3400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Organic Shampoo Set",
    description: "Duo set of sulfate-free shampoo and conditioner made with organic argan oil and aloe vera. Gently cleanses and deeply conditions without stripping natural oils. Vegan and cruelty-free. 12 oz each.",
    category: "Hair Care",
    price: 2800,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Beard Oil Kit",
    description: "Premium beard grooming kit with two natural beard oils (sandalwood and eucalyptus), a boar bristle brush, and a stainless steel comb. Softens, conditions, and tames facial hair. Comes in a gift-ready wooden box.",
    category: "Hair Care",
    price: 3200,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1621607512214-68297480165e?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1621607512214-68297480165e?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # FOOD & GROCERIES
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Organic Banana Bundle",
    description: "Fresh organic bananas sourced from sustainable farms. Naturally ripened and hand-selected for perfect sweetness. Rich in potassium and fiber. Approximately 6-8 bananas per bundle.",
    category: "Fresh Produce",
    price: 499,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Fresh Avocado Pack (6ct)",
    description: "Six perfectly ripe Hass avocados, ready to eat. Creamy texture and rich flavor ideal for guacamole, toast, or salads. Sourced from premium groves with sustainable farming practices.",
    category: "Fresh Produce",
    price: 899,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Premium Mixed Nuts 1lb",
    description: "Roasted and lightly salted mix of almonds, cashews, pecans, walnuts, and macadamia nuts. No artificial flavors or preservatives. High in protein and healthy fats. Resealable bag for freshness.",
    category: "Snacks",
    price: 1299,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Artisan Granola Bars (12pk)",
    description: "Handcrafted granola bars with rolled oats, dark chocolate chips, dried cranberries, and honey. No high-fructose corn syrup or artificial ingredients. 190 calories per bar. Perfect for on-the-go snacking.",
    category: "Snacks",
    price: 699,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1517093157656-b9eccef91cb1?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1517093157656-b9eccef91cb1?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Cold-Pressed Orange Juice",
    description: "Freshly cold-pressed orange juice made from Valencia oranges. No added sugar, preservatives, or water. Pure citrus flavor packed with vitamin C. 32 fl oz bottle. Refrigerate after opening.",
    category: "Beverages",
    price: 799,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Organic Honey Jar",
    description: "Raw, unfiltered organic wildflower honey sourced from local apiaries. Rich golden color with complex floral notes. Naturally crystallizes over time. Perfect for tea, baking, or drizzling. 16 oz glass jar.",
    category: "Pantry Essentials",
    price: 1499,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # RESTAURANT & MEALS
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Margherita Pizza Kit",
    description: "Restaurant-quality pizza kit with hand-stretched dough, San Marzano tomato sauce, fresh mozzarella, and basil. Makes two 12-inch pizzas. Just assemble and bake for 10 minutes at high heat. Serves 4.",
    category: "Pizza",
    price: 1699,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Wagyu Burger Kit",
    description: "Premium wagyu beef burger kit for two. Includes two 6oz wagyu patties, brioche buns, aged cheddar, house-made pickles, and secret sauce. A5 wagyu blend for unmatched juiciness and flavor.",
    category: "Burgers",
    price: 2499,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Sushi Platter Set",
    description: "Chef-curated sushi platter with 24 pieces including salmon nigiri, tuna sashimi, California rolls, and spicy tuna rolls. Includes wasabi, pickled ginger, and premium soy sauce. Serves 2-3.",
    category: "Sushi",
    price: 3499,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Tiramisu Dessert Kit",
    description: "Authentic Italian tiramisu kit with ladyfinger biscuits, mascarpone cream, premium espresso blend, and cocoa powder. Makes one 9x9 pan serving 6-8. Ready in 30 minutes plus chilling time.",
    category: "Desserts",
    price: 1899,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Premium Matcha Set",
    description: "Ceremonial-grade matcha tea set with 30g stone-ground matcha from Uji, Japan, a handcrafted bamboo whisk (chasen), bamboo scoop (chashaku), and ceramic matcha bowl. Everything for a perfect cup.",
    category: "Coffee & Tea",
    price: 2900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Artisan Coffee Bean Collection",
    description: "Curated collection of three single-origin specialty coffees: Ethiopian Yirgacheffe, Colombian Supremo, and Guatemalan Antigua. Freshly roasted in small batches. 12oz bags each. Whole bean for maximum freshness.",
    category: "Coffee & Tea",
    price: 2400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # DRINKS
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Cabernet Sauvignon Reserve",
    description: "Napa Valley reserve Cabernet Sauvignon aged 18 months in French oak barrels. Deep ruby color with notes of blackberry, dark cherry, vanilla, and tobacco. Full-bodied with velvety tannins and a long finish. 750ml, 14.5% ABV.",
    category: "Wine",
    price: 3900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "IPA Craft Beer 6-Pack",
    description: "West Coast style IPA brewed with Citra, Mosaic, and Simcoe hops. Bright citrus and tropical fruit aromas with a clean, bitter finish. 6.8% ABV. Six 12oz cans. Best enjoyed fresh and cold.",
    category: "Craft Beer",
    price: 1599,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1535958636474-b021ee887b13?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1535958636474-b021ee887b13?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Japanese Whisky 750ml",
    description: "Premium Japanese blended whisky with a smooth, delicate profile. Notes of honey, white peach, and toasted almond with a subtle smoky finish. Aged in Mizunara oak casks. 43% ABV. Best enjoyed neat or with a single ice cube.",
    category: "Spirits",
    price: 8900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1527281400683-1aae777175f8?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1527281400683-1aae777175f8?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Tropical Smoothie Mix",
    description: "Ready-to-blend tropical smoothie mix with freeze-dried mango, pineapple, passion fruit, and coconut. Just add water or your favorite milk. No added sugar. 10 individual serving packets. Packed with vitamins A and C.",
    category: "Smoothies & Juice",
    price: 1200,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1502741224143-90386d7f8c82?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1502741224143-90386d7f8c82?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Organic Green Tea Collection",
    description: "Collection of 5 premium organic green teas: Sencha, Genmaicha, Hojicha, Dragon Well, and Jasmine Pearl. 15 individually wrapped sachets of each variety. USDA Organic certified. Rich in antioxidants.",
    category: "Smoothies & Juice",
    price: 1800,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1556881286-fc6915169721?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1556881286-fc6915169721?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # BABY & KIDS
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Organic Cotton Onesie Set",
    description: "Set of 5 GOTS-certified organic cotton onesies in adorable prints. Envelope neckline for easy dressing, nickel-free snaps, and flat-lock seams for comfort against delicate skin. Machine washable. Available in 0-24 months.",
    category: "Baby Clothing",
    price: 2400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1522771930-78848d9293e8?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1522771930-78848d9293e8?w=800&q=80&fit=crop&crop=center",
    has_sizes: true,
    has_colors: false
  },
  {
    name: "Wooden Building Blocks",
    description: "Set of 60 premium hardwood building blocks in assorted shapes and colors. Non-toxic water-based paint and sanded smooth edges. Develops fine motor skills, spatial awareness, and creativity. Includes canvas storage bag. Ages 1+.",
    category: "Toys",
    price: 3400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Baby Monitor Camera",
    description: "HD 1080p baby monitor with night vision, two-way audio, and temperature/humidity sensing. Lullaby player with 10 built-in melodies. Pan, tilt, and 4x zoom. Encrypted Wi-Fi connection with smartphone alerts.",
    category: "Baby Care",
    price: 9900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Children's Art Supply Kit",
    description: "Comprehensive art kit with 120 pieces including crayons, colored pencils, markers, watercolors, pastels, and sketch paper. Organized in a sturdy wooden carrying case. Non-toxic and washable. Ages 4+.",
    category: "Kids Education",
    price: 2900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # PET SUPPLIES
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Premium Dog Food 15lb",
    description: "Grain-free premium dog food with real deboned chicken as the first ingredient. Fortified with probiotics, omega fatty acids, and glucosamine for joint health. No artificial colors, flavors, or preservatives. All life stages.",
    category: "Dogs",
    price: 4900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Cat Scratching Tower",
    description: "Multi-level cat tower with sisal scratching posts, plush perches, and a cozy hideaway cave. 48 inches tall with a sturdy wide base for stability. Replaceable scratching posts. Easy assembly with all hardware included.",
    category: "Cats",
    price: 6900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Automatic Pet Feeder",
    description: "Smart automatic pet feeder with Wi-Fi app control and programmable meal schedules. 4-liter capacity with portion control from 1/12 to 4 cups per meal. Voice recording feature to call your pet. Battery backup for power outages.",
    category: "Dogs",
    price: 7900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1583337130417-13104dec14a5?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1583337130417-13104dec14a5?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Luxury Pet Bed",
    description: "Orthopedic memory foam pet bed with bolstered sides for head and neck support. Removable, machine-washable faux-fur cover. Non-slip rubber bottom. Fits dogs up to 50 lbs. Available in multiple neutral colors.",
    category: "Cats",
    price: 5900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # BOOKS & STATIONERY
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Bestseller Novel Collection",
    description: "Curated collection of 4 award-winning novels spanning literary fiction, thriller, and contemporary genres. Hardcover editions with dust jackets. Includes a bookmark and reading guide. Perfect for book clubs.",
    category: "Fiction",
    price: 2400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Leather-Bound Journal",
    description: "Handcrafted genuine leather journal with 240 pages of acid-free, fountain-pen-friendly paper. Wraparound leather strap closure and ribbon bookmark. 5\" x 7\" size fits perfectly in a bag. Ages beautifully with use.",
    category: "Journals",
    price: 3400,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1531346878377-a5be20888e57?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1531346878377-a5be20888e57?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Premium Pen Set",
    description: "Luxury pen set featuring a stainless steel fountain pen and matching ballpoint pen. Iridium-tipped nib for smooth writing. Includes two ink cartridges and a converter for bottled ink. Presented in a gift box.",
    category: "Journals",
    price: 4900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Watercolor Paint Kit",
    description: "Professional watercolor set with 36 vibrant pans, 3 round brushes, a water brush pen, and a mixing palette. Artist-grade pigments with excellent lightfastness. Compact tin case for plein air painting.",
    category: "Art Supplies",
    price: 3900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # AUTOMOTIVE
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Dash Cam 4K",
    description: "Ultra HD 4K dash camera with 170-degree wide-angle lens and superior night vision. Built-in GPS logging, G-sensor for incident detection, and loop recording. Includes 32GB microSD card. Discreet, compact design.",
    category: "Car Accessories",
    price: 12900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Car Phone Mount",
    description: "Universal car phone mount with strong suction cup and adjustable arm. 360-degree rotation and one-touch release. Compatible with phones up to 6.7 inches. Dashboard and windshield compatible. Vibration-dampening base.",
    category: "Car Accessories",
    price: 1900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1586816879360-004f5b0c51e5?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1586816879360-004f5b0c51e5?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Premium Car Wax Kit",
    description: "Professional-grade car detailing kit with carnauba wax, microfiber towels, foam applicator pads, and spray detailer. Provides up to 6 months of protection with a deep, wet-look shine. Safe for all paint types.",
    category: "Car Care",
    price: 2900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Portable Tire Inflator",
    description: "Compact digital tire inflator with preset pressure and auto-shutoff. 150 PSI max pressure. Built-in LED flashlight and rechargeable lithium battery. Inflates a standard car tire in under 5 minutes. Includes valve adapters.",
    category: "Tools",
    price: 4900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800&q=80&fit=crop",
    image_url_alt: "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800&q=80&fit=crop&crop=bottom",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # SOLAR & RENEWABLE ENERGY
  # ══════════════════════════════════════════════════════════════════

  {
    name: "200W Monocrystalline Solar Panel",
    description: "High-efficiency 200W monocrystalline solar panel with 21.5% conversion rate. Ideal for residential rooftop installations. Can power: 2 fans, 5 LED bulbs, phone charging, and a small TV for 6-8 hours daily when paired with a 200Ah battery. IP68 waterproof, 25-year warranty.",
    category: "Solar Panels",
    price: 18900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "400W Solar Panel Kit",
    description: "Dual 200W panel kit for serious solar setups. Combined 400W output. Can power: entire small apartment including fridge, fans, lights, TV, and multiple devices. Includes MC4 connectors and parallel wiring harness.",
    category: "Solar Panels",
    price: 35900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "100Ah LiFePO4 Lithium Battery",
    description: "Deep cycle 100Ah LiFePO4 battery with built-in BMS. 4000+ cycle life, 10-year warranty. Can power: full home setup (fans, lights, TV, laptop, small fridge) for 8-12 hours. 95% DOD. 12kg — 70% lighter than lead-acid.",
    category: "Lithium Batteries",
    price: 44900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "200Ah Lithium Battery",
    description: "Heavy-duty 200Ah LiFePO4 for whole-home solar systems. Powers: 3-bedroom home with AC, fridge, washing machine for 12-18 hours. Built-in Bluetooth monitoring. 5000+ cycles.",
    category: "Lithium Batteries",
    price: 84900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6?w=800&q=80&fit=crop&crop=top",
    image_url_alt: "https://images.unsplash.com/photo-1611348524140-53c9a25263d6?w=800&q=80&fit=crop&crop=bottom",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "220Ah Tubular Battery",
    description: "Heavy-duty 220Ah tubular lead-acid battery for solar and inverter. Thick tubular plates for deep discharge. Powers: basic home (fans, lights, TV) for 10-14 hours. 1500 cycles at 80% DOD. Ideal for frequent power outages.",
    category: "Tubular Batteries",
    price: 29900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "3.5KVA Hybrid Solar Inverter",
    description: "Pure sine wave 3.5KVA hybrid inverter with 60A MPPT charge controller. Solar, grid, and generator input. Powers: refrigerator, washing machine, 1HP AC, TV, fans, lights simultaneously. LCD display, Wi-Fi monitoring.",
    category: "Inverters",
    price: 69900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "5KVA Solar Inverter",
    description: "Industrial-grade 5KVA pure sine wave inverter for large homes and small businesses. Dual MPPT, 80A charge controller. Powers: full 4-bedroom home including 2 ACs, deep freezer, and water pump. Stackable for 10KVA.",
    category: "Inverters",
    price: 129900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800&q=80&fit=crop&crop=top",
    image_url_alt: "https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800&q=80&fit=crop&crop=bottom",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Complete Home Solar Kit 5KVA",
    description: "All-in-one 5KVA solar system: inverter, 4x400W panels (1.6KW), 2x200Ah lithium batteries (400Ah), mounting brackets, cables, installation guide. Powers: entire 3-bedroom home including AC, fridge, washing machine. 15+ hours daily. Save $200/month on electricity.",
    category: "Solar Panels",
    price: 349900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80&fit=crop",
    image_url_alt: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Solar Charge Controller 60A MPPT",
    description: "Advanced 60A MPPT solar charge controller with 98% efficiency. Supports 12V/24V/48V systems. LCD display with real-time monitoring. Protects batteries from overcharge, over-discharge, and short circuit.",
    category: "Solar Accessories",
    price: 14900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80&fit=crop&crop=center",
    image_url_alt: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80&fit=crop&crop=bottom",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Solar Panel Mounting Brackets Set",
    description: "Universal aluminum mounting brackets for rooftop solar installations. Set of 4 adjustable brackets (15-45 degree tilt). Supports panels up to 500W. Corrosion-resistant, stainless steel hardware included.",
    category: "Solar Accessories",
    price: 7900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=800&q=80&fit=crop",
    image_url_alt: "https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Solar Installation Service",
    description: "Professional installation for residential solar up to 10KVA. Includes: site assessment, roof mounting, panel installation, inverter setup, battery wiring, grid connection, testing. 1-year installation warranty.",
    category: "Installation Services",
    price: 49900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80&fit=crop&crop=top",
    image_url_alt: "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80&fit=crop&crop=left",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Solar Maintenance Package",
    description: "Quarterly maintenance: panel cleaning, connection inspection, battery health check, inverter diagnostics, performance report. Keeps your system at peak efficiency.",
    category: "Installation Services",
    price: 9900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=800&q=80&fit=crop&crop=top",
    image_url_alt: "https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=800&q=80&fit=crop&crop=bottom",
    has_sizes: false,
    has_colors: false
  },

  # ══════════════════════════════════════════════════════════════════
  # GAMING
  # ══════════════════════════════════════════════════════════════════

  {
    name: "Wireless Gaming Controller",
    description: "Ergonomic wireless gaming controller with hall-effect analog sticks for zero drift. Tri-mode connectivity (2.4GHz, Bluetooth, USB-C). Customizable back buttons, adjustable triggers, and vibration motors. 40-hour battery life.",
    category: "Gaming Accessories",
    price: 5900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1592840496694-26d035b52b48?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1592840496694-26d035b52b48?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Gaming Headset RGB",
    description: "Surround sound gaming headset with 50mm drivers and customizable RGB lighting. Detachable noise-canceling microphone with AI-powered voice clarity. Memory foam ear cushions and lightweight design for marathon sessions.",
    category: "Gaming Accessories",
    price: 8900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Streaming Webcam 4K",
    description: "Professional 4K webcam with auto-focus, HDR, and AI-powered framing. Built-in ring light with 3 brightness levels. Privacy shutter and dual noise-reducing microphones. Compatible with all major streaming platforms.",
    category: "PC Gaming",
    price: 12900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1587826080692-f439cd0b70da?w=800&q=80",
    image_url_alt: "https://images.unsplash.com/photo-1587826080692-f439cd0b70da?w=800&q=80&fit=crop&crop=center",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "RGB Mousepad XL",
    description: "Extra-large RGB gaming mousepad (900x400mm) with 12 lighting modes and smooth micro-textured surface. Non-slip rubber base and waterproof coating. USB-powered with passthrough port. Optimized for both optical and laser sensors.",
    category: "Gaming Accessories",
    price: 2900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1527814050087-3793815479db?w=800&q=80&fit=crop",
    image_url_alt: "https://images.unsplash.com/photo-1527814050087-3793815479db?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },

  # ── Additional products to reach 100+ ──
  {
    name: "Smartphone Gimbal Stabilizer",
    description: "3-axis smartphone gimbal with AI tracking and gesture control. Foldable design fits in a pocket. Built-in extension rod and tripod. 15-hour battery life. Compatible with all smartphones. Perfect for vlogging and content creation.",
    category: "Smartphones",
    price: 9900,
    compare_at: 12900,
    image_url: "https://images.unsplash.com/photo-1586816879360-004f5b0c51e5?w=800&q=80&fit=crop&crop=top",
    image_url_alt: "https://images.unsplash.com/photo-1586816879360-004f5b0c51e5?w=800&q=80&fit=crop&crop=bottom",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Non-Fiction Book Bundle",
    description: "Collection of 3 bestselling non-fiction titles covering business, psychology, and personal development. Paperback editions with author notes. Curated for lifelong learners and ambitious professionals.",
    category: "Non-Fiction",
    price: 1900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800&q=80&fit=crop",
    image_url_alt: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Cycling Jersey Pro",
    description: "Aerodynamic cycling jersey with moisture-wicking fabric and full-length zipper. Three rear pockets and reflective elements for visibility. Italian-made fabric with UPF 50+ sun protection. Race-fit cut.",
    category: "Cycling",
    price: 8900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80&fit=crop",
    image_url_alt: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80&fit=crop&crop=top",
    has_sizes: true,
    has_colors: true
  },
  {
    name: "Aquarium Starter Kit",
    description: "Complete 10-gallon aquarium kit with LED lighting, whisper-quiet filter, heater, and thermometer. Includes water conditioner and fish food sample. Crystal-clear glass with black silicone trim. Perfect for beginners.",
    category: "Fish & Aquarium",
    price: 7900,
    compare_at: nil,
    image_url: "https://images.unsplash.com/photo-1583337130417-13104dec14a5?w=800&q=80&fit=crop",
    image_url_alt: "https://images.unsplash.com/photo-1583337130417-13104dec14a5?w=800&q=80&fit=crop&crop=top",
    has_sizes: false,
    has_colors: false
  },
  {
    name: "Fitness Tracker Band",
    description: "Slim fitness tracker with heart rate monitoring, step counting, and sleep analysis. Water-resistant to 50m. 14-day battery life with always-on display. Interchangeable silicone bands. Syncs with iOS and Android.",
    category: "Wearables",
    price: 4900,
    compare_at: 6900,
    image_url: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80&fit=crop",
    image_url_alt: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80&fit=crop&crop=top",
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
  { user: customers[7], line1: "753 Walnut Way", city: "Denver", state: "CO", zip: "80201", phone: "555-0800" },
  { user: customers[8], line1: "246 Spruce Street", city: "Portland", state: "OR", zip: "97201", phone: "555-0900" },
  { user: customers[9], line1: "864 Willow Lane", city: "Nashville", state: "TN", zip: "37201", phone: "555-1000" },
  { user: customers[10], line1: "135 Aspen Way", city: "Boston", state: "MA", zip: "02101", phone: "555-1100" },
  { user: customers[11], line1: "579 Redwood Drive", city: "Phoenix", state: "AZ", zip: "85001", phone: "555-1200" }
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

  25.times do |i|
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
      created_at: rand(60).days.ago
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

# ─── Sample Reviews ───────────────────────────────────────────────
if Review.count == 0
  reviews_data = [
    { product_name: "Essential Cotton Crew Tee", user_idx: 0, rating: 5, title: "Best basic tee ever", body: "Incredibly soft and the fit is perfect. I ordered 3 more in different colors. The quality is noticeably better than other brands at this price point." },
    { product_name: "AeroSound Pro Wireless Headphones", user_idx: 1, rating: 5, title: "Studio quality sound", body: "The noise cancellation is phenomenal and the sound quality rivals headphones twice the price. Battery life is exactly as advertised. Worth every penny." },
    { product_name: "Apex Smart Watch Series 5", user_idx: 2, rating: 4, title: "Great fitness tracker", body: "Love the sleep tracking and heart rate monitoring. The battery easily lasts a week. Only wish the screen was a bit brighter in direct sunlight." },
    { product_name: "Carbon Plate Running Shoes", user_idx: 3, rating: 5, title: "PR machine", body: "Knocked 3 minutes off my half marathon time. The carbon plate gives incredible energy return. They feel fast from the first step." },
    { product_name: "Heritage Leather Tote", user_idx: 4, rating: 5, title: "Beautiful craftsmanship", body: "The leather quality is outstanding. Already developing a gorgeous patina after just a month of use. Spacious enough for my laptop and daily essentials." },
    { product_name: "ProBook Ultra 15\" Laptop", user_idx: 5, rating: 4, title: "Incredible display", body: "The OLED screen is stunning for photo and video editing. Performance is blazing fast. Runs cool and quiet. Only minor gripe is the webcam could be better." },
    { product_name: "Heavyweight French Terry Hoodie", user_idx: 6, rating: 5, title: "My favorite hoodie", body: "The weight and quality of this hoodie is unmatched. Super cozy and looks great. I wear it almost every day. Already got compliments from friends." },
    { product_name: "Botanical Face Serum", user_idx: 7, rating: 4, title: "Noticeable results", body: "After 3 weeks my skin looks brighter and more hydrated. Absorbs quickly without feeling greasy. A little goes a long way with this concentrated formula." },
    { product_name: "Margherita Pizza Kit", user_idx: 0, rating: 5, title: "Better than delivery", body: "Restaurant quality pizza at home in 10 minutes. The San Marzano sauce and fresh mozzarella make all the difference. My family loved it!" },
    { product_name: "Sushi Platter Set", user_idx: 2, rating: 5, title: "Incredibly fresh", body: "The fish was exceptionally fresh and the portions were generous. The presentation was beautiful. Perfect for our date night at home." },
    { product_name: "200W Monocrystalline Solar Panel", user_idx: 3, rating: 5, title: "Excellent efficiency", body: "Installed two of these on my roof and they consistently produce near-rated output even on partly cloudy days. Build quality is solid and the 25-year warranty gives peace of mind." },
    { product_name: "Complete Home Solar Kit 5KVA", user_idx: 5, rating: 5, title: "Life-changing investment", body: "This kit has completely eliminated our electricity bills. Installation was straightforward and the system powers our entire 3-bedroom home including AC. Best purchase we have ever made." },
    { product_name: "Japanese Whisky 750ml", user_idx: 1, rating: 5, title: "Smooth and complex", body: "Incredibly smooth with beautiful layers of flavor. The Mizunara oak aging adds a unique character you cannot find in other whiskies. A must-try for any whisky enthusiast." },
    { product_name: "Wireless Gaming Controller", user_idx: 7, rating: 4, title: "Great value controller", body: "Hall-effect sticks are a game changer, no more drift worries. Battery lasts forever. The back buttons took some getting used to but now I cannot play without them." },
    { product_name: "Premium Dog Food 15lb", user_idx: 4, rating: 5, title: "My dog loves it", body: "Switched from a big-box brand and the difference is remarkable. My golden retriever's coat is shinier and she has so much more energy. No more digestive issues either." },
    { product_name: "Leather-Bound Journal", user_idx: 6, rating: 5, title: "Gorgeous journal", body: "The leather smells amazing and the paper quality is superb. My fountain pen glides beautifully with zero bleeding. This will be a treasured possession for years." },
    { product_name: "Cast Iron Skillet", user_idx: 8, rating: 5, title: "Kitchen essential", body: "The pre-seasoning on this skillet is excellent right out of the box. Perfect sear on steaks every time. Heavy and solid, this will last a lifetime." },
    { product_name: "Cabernet Sauvignon Reserve", user_idx: 9, rating: 4, title: "Excellent everyday wine", body: "Rich and smooth with great complexity for the price. Pairs wonderfully with grilled meats and aged cheeses. Will definitely be ordering more." },
    { product_name: "Adjustable Dumbbell Set", user_idx: 10, rating: 5, title: "Gym replacement", body: "Replaced my entire dumbbell rack with these. The dial system is smooth and locks securely. Saved so much space in my home gym. Build quality is top notch." },
    { product_name: "Organic Cotton Onesie Set", user_idx: 11, rating: 5, title: "So soft for baby", body: "These are the softest onesies we have found for our newborn. The snaps are easy to use during late-night diaper changes and they wash beautifully without shrinking." }
  ]

  reviews_data.each do |data|
    product = Product.find_by(name: data[:product_name])
    next unless product

    Review.find_or_create_by!(product: product, user: customers[data[:user_idx]]) do |r|
      r.rating = data[:rating]
      r.title = data[:title]
      r.body = data[:body]
      r.status = :approved
      r.created_at = rand(30).days.ago
    end
  end
  puts "  #{Review.count} reviews created"
end

# ─── Static Pages ─────────────────────────────────────────────────
pages_data = [
  {
    title: "About Us",
    body: "RailsyCommerce is a luxury e-commerce platform built with care and attention to detail. We curate the finest products from around the world, bringing them together in one beautiful shopping experience.\n\nOur mission is to make premium shopping accessible, enjoyable, and sustainable. Every product in our collection meets our rigorous standards for quality, craftsmanship, and ethical sourcing.\n\nFounded in 2024, we've grown from a small team of passionate curators to a global marketplace serving customers in over 50 countries.",
    position: 0
  },
  {
    title: "Contact",
    body: "We'd love to hear from you.\n\nEmail: hello@railsycommerce.com\nPhone: 1-800-RAILSY (1-800-724-5799)\n\nCustomer Support Hours:\nMonday - Friday: 9am - 6pm EST\nSaturday: 10am - 4pm EST\nSunday: Closed\n\nHeadquarters:\n123 Commerce Street\nNew York, NY 10001\nUnited States",
    position: 1
  },
  {
    title: "FAQ",
    body: "Frequently Asked Questions\n\nHow long does shipping take?\nStandard shipping takes 5-7 business days. Express shipping delivers in 1-2 business days.\n\nWhat is your return policy?\nWe offer a 30-day return policy on all items in original condition. See our Return Policy page for details.\n\nDo you ship internationally?\nYes! We ship to over 50 countries worldwide. International shipping times vary by destination.\n\nHow do I track my order?\nOnce your order ships, you'll receive a tracking number via email. You can also track your order from your account dashboard.\n\nAre your products authentic?\nAbsolutely. We source directly from brands and authorized distributors. Every product is guaranteed authentic.",
    position: 2
  },
  {
    title: "Shipping Policy",
    body: "Shipping Information\n\nFree Standard Shipping on orders over $75.\n\nStandard Shipping: $9.99 (5-7 business days)\nExpress Shipping: $24.99 (1-2 business days)\nFree Shipping: $0 (7-10 business days, orders over $75)\n\nAll orders are processed within 1-2 business days. You will receive a confirmation email with tracking information once your order has shipped.\n\nInternational Shipping:\nWe ship to most countries worldwide. International shipping rates and delivery times vary by destination. Customs duties and taxes may apply and are the responsibility of the recipient.",
    position: 3
  },
  {
    title: "Return Policy",
    body: "Returns & Exchanges\n\nWe want you to love your purchase. If you're not completely satisfied, we're here to help.\n\n30-Day Return Window:\nYou have 30 days from the date of delivery to initiate a return for a full refund.\n\nConditions:\n- Items must be in original, unworn condition with all tags attached\n- Items must be returned in original packaging\n- Sale items are final sale and cannot be returned\n- Personalized items cannot be returned\n\nHow to Start a Return:\n1. Log into your account\n2. Go to your order history\n3. Click 'Request Return' on the order\n4. Follow the instructions provided\n\nRefunds are processed within 5-10 business days of receiving your return.",
    position: 4
  }
]

pages_data.each do |data|
  Page.find_or_create_by!(title: data[:title]) do |p|
    p.body = data[:body]
    p.position = data[:position]
    p.published = true
  end
end
puts "  #{Page.count} pages created"

# ─── Product Relations ────────────────────────────────────────────
if ProductRelation.count == 0
  products_list = Product.active.to_a
  products_list.each do |product|
    # Add 2-3 related products from the same category
    same_category = products_list.select { |p| p.category_id == product.category_id && p.id != product.id }
    other_products = products_list.select { |p| p.category_id != product.category_id && p.id != product.id }

    related = same_category.sample([2, same_category.size].min) + other_products.sample(1)
    related.compact.each_with_index do |rel, i|
      ProductRelation.find_or_create_by!(product: product, related_product: rel) do |pr|
        pr.relation_type = i == 0 ? :related : [:cross_sell, :up_sell].sample
        pr.position = i
      end
    end
  end
  puts "  #{ProductRelation.count} product relations created"
end

# ─── Promotions ───────────────────────────────────────────────────
Promotion.find_or_create_by!(name: "Free Shipping Over $75") do |p|
  p.promotion_type = :free_shipping
  p.conditions = { minimum_total_cents: 7500 }
  p.active = true
  p.auto_apply = true
end

Promotion.find_or_create_by!(name: "Summer Category Sale") do |p|
  p.promotion_type = :percentage_off_category
  clothing = Category.find_by(name: "Fashion & Clothing")
  p.conditions = { percentage: 15, category_id: clothing&.id }
  p.active = false
  p.auto_apply = false
  p.starts_at = 1.month.from_now
  p.expires_at = 3.months.from_now
end
puts "  #{Promotion.count} promotions created"

# ─── Store Config: Currency ───────────────────────────────────────
StoreConfig.set("store_currency", "USD")
StoreConfig.set("supported_currencies", "USD,EUR,GBP,CAD,AUD,JPY")
StoreConfig.set("setup_complete", "true")

# ─── Theme Settings ──────────────────────────────────────────────
theme_settings_data = [
  # General
  { key: "store_display_name", value: "RailsyCommerce", setting_type: "text", group: "general", label: "Store Display Name", description: "The name shown in the header and browser tab", position: 0 },
  { key: "tagline", value: "Premium Marketplace", setting_type: "text", group: "general", label: "Tagline", description: "Short tagline displayed below the store name", position: 1 },
  { key: "logo_url", value: "", setting_type: "image", group: "general", label: "Logo URL", description: "URL to your store logo image (leave blank for text logo)", position: 2 },
  { key: "favicon_url", value: "", setting_type: "image", group: "general", label: "Favicon URL", description: "URL to your favicon image", position: 3 },

  # Colors
  { key: "primary_color", value: "#c9a96e", setting_type: "color", group: "colors", label: "Primary Color", description: "Main accent color used for buttons, links, and highlights (default: gold)", position: 0 },
  { key: "secondary_color", value: "#1a1a1a", setting_type: "color", group: "colors", label: "Secondary Color", description: "Dark color used for headings and backgrounds", position: 1 },
  { key: "accent_color", value: "#d4b97e", setting_type: "color", group: "colors", label: "Accent Color", description: "Lighter accent for hover states and highlights", position: 2 },

  # Hero
  { key: "hero_headline", value: "Discover What's Next", setting_type: "text", group: "hero", label: "Hero Headline", description: "Main headline on the homepage hero section", position: 0 },
  { key: "hero_subtext", value: "From cutting-edge tech to timeless home essentials — everything you need, beautifully curated and delivered to your door.", setting_type: "text", group: "hero", label: "Hero Subtext", description: "Supporting text below the headline", position: 1 },
  { key: "hero_cta_text", value: "Shop Now", setting_type: "text", group: "hero", label: "Hero CTA Text", description: "Text for the main call-to-action button", position: 2 },
  { key: "hero_cta_link", value: "/products", setting_type: "text", group: "hero", label: "Hero CTA Link", description: "URL the CTA button links to", position: 3 },
  { key: "hero_bg_image", value: "", setting_type: "image", group: "hero", label: "Hero Background Image URL", description: "Custom background image for the hero section", position: 4 },

  # Header
  { key: "announcement_text", value: "Free shipping on all orders over $75 — no code needed", setting_type: "text", group: "header", label: "Announcement Bar Text", description: "Text shown in the top announcement bar", position: 0 },
  { key: "announcement_enabled", value: "true", setting_type: "boolean", group: "header", label: "Show Announcement Bar", description: "Toggle the announcement bar on or off", position: 1 },
  { key: "show_search_bar", value: "true", setting_type: "boolean", group: "header", label: "Show Search Bar", description: "Display the search bar in the header", position: 2 },

  # Footer
  { key: "footer_tagline", value: "Your one-stop marketplace for everything — from electronics to home essentials, fashion to fitness. Quality products, exceptional service.", setting_type: "text", group: "footer", label: "Footer Tagline", description: "Text shown in the footer brand section", position: 0 },
  { key: "copyright_text", value: "RailsyCommerce. All rights reserved.", setting_type: "text", group: "footer", label: "Copyright Text", description: "Copyright notice in the footer", position: 1 },
  { key: "show_newsletter", value: "true", setting_type: "boolean", group: "footer", label: "Show Newsletter Section", description: "Display the newsletter signup section on the homepage", position: 2 },

  # Social Media
  { key: "instagram_url", value: "", setting_type: "text", group: "social", label: "Instagram URL", description: "Link to your Instagram profile", position: 0 },
  { key: "twitter_url", value: "", setting_type: "text", group: "social", label: "Twitter / X URL", description: "Link to your Twitter/X profile", position: 1 },
  { key: "facebook_url", value: "", setting_type: "text", group: "social", label: "Facebook URL", description: "Link to your Facebook page", position: 2 },
  { key: "tiktok_url", value: "", setting_type: "text", group: "social", label: "TikTok URL", description: "Link to your TikTok profile", position: 3 },
  { key: "youtube_url", value: "", setting_type: "text", group: "social", label: "YouTube URL", description: "Link to your YouTube channel", position: 4 },
  { key: "linkedin_url", value: "", setting_type: "text", group: "social", label: "LinkedIn URL", description: "Link to your LinkedIn page", position: 5 }
]

theme_settings_data.each do |data|
  ThemeSetting.find_or_create_by!(key: data[:key]) do |ts|
    ts.value = data[:value]
    ts.setting_type = data[:setting_type]
    ts.group = data[:group]
    ts.label = data[:label]
    ts.description = data[:description]
    ts.position = data[:position]
  end
end
puts "  #{ThemeSetting.count} theme settings created"

puts ""
puts "Seeding complete!"
# ─── Vendor User ──────────────────────────────────────────────────
vendor = User.find_or_create_by!(email_address: "vendor@example.com") do |u|
  u.password = "password"
  u.first_name = "Solar"
  u.last_name = "Solutions"
  u.role = :vendor
  u.vendor_name = "GreenPower Solar"
  u.vendor_description = "Nigeria's leading solar energy provider. We supply panels, batteries, inverters, and complete installation services."
  u.phone = "+234 800 123 4567"
  u.vendor_verified = true
end
puts "  Vendor: vendor@example.com / password (GreenPower Solar)"

# Assign solar products to vendor
Category.find_by(name: "Solar & Renewable Energy")&.children&.each do |cat|
  cat.products.update_all(vendor_id: vendor.id)
end

# ─── Demo Customer Data (customer@example.com) ──────────────────
demo_customer = User.find_by(email_address: "customer@example.com")
if demo_customer
  # Wishlist
  wishlist = demo_customer.wishlist || demo_customer.create_wishlist
  if wishlist.wishlist_items.empty?
    popular = Variant.where(is_master: true).limit(5)
    popular.each { |v| wishlist.wishlist_items.find_or_create_by!(variant: v) }
    puts "  Added #{wishlist.wishlist_items.count} items to demo customer wishlist"
  end

  # Ensure demo customer has an address
  if demo_customer.addresses.empty?
    demo_customer.addresses.create!(
      first_name: "Alex", last_name: "Taylor",
      address_line_1: "42 Commerce Street", city: "Lagos",
      state: "LA", postal_code: "100001", country_code: "NG",
      phone: "+234 812 345 6789"
    )
  end

  # Tracking updates for demo customer orders
  demo_customer.orders.limit(3).each_with_index do |order, idx|
    next if order.tracking_updates.any?

    order.update!(tracking_number: "TRK#{SecureRandom.alphanumeric(10).upcase}")

    base_time = order.created_at
    updates = [
      { status: "order_placed", description: "Your order has been received and is being processed.", location: "Online", created_at: base_time },
      { status: "confirmed", description: "Payment confirmed. Your order is being prepared.", location: "Lagos Fulfillment Center", created_at: base_time + 2.hours }
    ]

    if idx > 0
      updates += [
        { status: "processing", description: "Your items have been picked and packed.", location: "Lagos Fulfillment Center", created_at: base_time + 1.day },
        { status: "picked_up", description: "Package picked up by courier.", location: "Lagos Hub", created_at: base_time + 1.day + 4.hours }
      ]
    end

    if idx > 1
      updates += [
        { status: "in_transit", description: "Package in transit to your city.", location: "National Sorting Center", created_at: base_time + 2.days },
        { status: "out_for_delivery", description: "Your package is out for delivery. Estimated arrival today.", location: "Local Delivery Station", created_at: base_time + 3.days, estimated_delivery: base_time + 3.days + 6.hours }
      ]
    end

    updates.each do |data|
      order.tracking_updates.find_or_create_by!(status: data[:status]) do |tu|
        tu.description = data[:description]
        tu.location = data[:location]
        tu.estimated_delivery = data[:estimated_delivery]
        tu.created_at = data[:created_at]
      end
    end
  end
  puts "  Added tracking updates for demo customer orders"
end

puts ""
puts "Seeding complete!"
puts "  Products: #{Product.count}"
puts "  Categories: #{Category.count} (#{Category.roots.count} root)"
puts "  Variants: #{Variant.count}"
puts "  Orders: #{Order.count}"
puts "  Reviews: #{Review.count}"
puts "  Users: #{User.count} (#{User.customer.count} customers)"
puts "  Pages: #{Page.count}"
puts "  Product Relations: #{ProductRelation.count}"
puts "  Promotions: #{Promotion.count}"
