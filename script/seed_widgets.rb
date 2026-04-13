# Idempotent seed for banners, brands, and a running flash sale.
# Usage (local or production):
#   bin/rails runner script/seed_widgets.rb
require "open-uri"

if Banner.count == 0
  puts "Seeding banners..."
  [
    { eyebrow: "Premium Marketplace", title: "Discover Whats Next",
      subtitle: "From cutting-edge tech to timeless home essentials.",
      link_text: "Shop Now", link_url: "/products", position: 0 },
    { eyebrow: "New Arrivals", title: "Sound Redefined",
      subtitle: "Premium audio gear from the brands audiophiles trust.",
      link_text: "Explore Audio", link_url: "/products", position: 1 },
    { eyebrow: "Home & Living", title: "Light Up Your Space",
      subtitle: "Modern lamps and decor.",
      link_text: "Shop Home", link_url: "/products", position: 2 },
    { eyebrow: "Editor's Pick", title: "Crafted For You",
      subtitle: "Handpicked pieces that blend style and everyday utility.",
      link_text: "See Picks", link_url: "/products", position: 3 }
  ].each { |a| Banner.create!(a.merge(active: true)) }

  unsplash_urls = [
    "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=1920&q=80",
    "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1920&q=80",
    "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=1920&q=80",
    "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=1920&q=80"
  ]
  Banner.ordered.each_with_index do |banner, i|
    next if banner.image.attached?
    url = unsplash_urls[i] || unsplash_urls.first
    begin
      io = URI.open(url)
      banner.image.attach(io: io, filename: "#{banner.id}.jpg", content_type: "image/jpeg")
    rescue => e
      puts "  ! banner image #{banner.id}: #{e.message[0, 60]}"
    end
  end
  puts "  created #{Banner.count} banners"
end

if Brand.count == 0
  puts "Seeding brands..."
  colors = %w[000000 1e293b 7c2d12 155e75 4a044e 831843 365314 0f172a]
  %w[Sony Apple Samsung LG Dell Nike Adidas Bose].each_with_index do |name, i|
    brand = Brand.create!(name: name, active: true, featured: i < 6, position: i)
    begin
      url = "https://dummyimage.com/400x200/#{colors[i]}/ffffff.png&text=#{URI.encode_www_form_component(name)}"
      io = URI.open(url)
      brand.logo.attach(io: io, filename: "#{brand.slug}.png", content_type: "image/png")
    rescue => e
      puts "  ! logo for #{name}: #{e.message[0, 60]}"
    end
  end

  ids = Brand.pluck(:id)
  Product.where(brand_id: nil).find_each { |p| p.update_column(:brand_id, ids.sample) }
  puts "  created #{Brand.count} brands, linked #{Product.where.not(brand_id: nil).count} products"
end

if defined?(Ad) && Ad.count == 0
  puts "Seeding ads..."
  ads = [
    { title: "Summer Collection", subtitle: "Up to 40% off new arrivals",
      link_url: "/products", placement: "home_mid", position: 0,
      image_url: "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=1600&q=80" },
    { title: "Tech Essentials", subtitle: "Gadgets that make life easier",
      link_url: "/products", placement: "home_mid", position: 1,
      image_url: "https://images.unsplash.com/photo-1518770660439-4636190af475?w=1600&q=80" },
    { title: "Clearance Event",
      subtitle: "Final markdowns on last-season styles — while they last.",
      link_url: "/products?on_sale=true", placement: "home_bottom", position: 0,
      image_url: "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=1600&q=80" }
  ]
  ads.each do |attrs|
    image_url = attrs.delete(:image_url)
    ad = Ad.create!(attrs.merge(active: true))
    begin
      io = URI.open(image_url)
      ad.image.attach(io: io, filename: "ad-#{ad.id}.jpg", content_type: "image/jpeg")
    rescue => e
      puts "  ! ad image for #{ad.title}: #{e.message[0, 60]}"
    end
  end
  puts "  created #{Ad.count} ads"
end

if FlashSale.running.none?
  puts "Seeding flash sale..."
  sale = FlashSale.create!(
    name: "Weekend Mega Sale",
    description: "48 hours of deep discounts across our most popular picks. Don't miss out.",
    starts_at: 1.hour.ago,
    ends_at: 2.days.from_now,
    discount_percentage: 30,
    active: true
  )
  Product.active.order("RANDOM()").limit(10).each { |p| sale.flash_sale_products.create!(product: p) }
  puts "  created '#{sale.name}' with #{sale.products.count} products"
end

puts ""
puts "Summary:"
puts "  Banners:     #{Banner.count}"
puts "  Brands:      #{Brand.count} (#{Brand.featured.count} featured)"
puts "  Flash sales: #{FlashSale.count} (#{FlashSale.running.count} running)"
puts "  Ads:         #{Ad.count}" if defined?(Ad)
