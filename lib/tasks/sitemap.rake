namespace :sitemap do
  desc "Generate sitemap.xml in public directory"
  task generate: :environment do
    include Rails.application.routes.url_helpers

    default_url_options[:host] = ENV.fetch("APP_HOST", "https://railsycommerce.com")

    urls = []

    # Static pages
    urls << { loc: root_url, changefreq: "daily", priority: "1.0" }

    # Products
    Product.active.find_each do |product|
      urls << {
        loc: product_url(product),
        lastmod: product.updated_at.iso8601,
        changefreq: "weekly",
        priority: "0.8"
      }
    end

    # Categories
    Category.active.find_each do |category|
      urls << {
        loc: category_url(category),
        lastmod: category.updated_at.iso8601,
        changefreq: "weekly",
        priority: "0.7"
      }
    end

    # Build XML
    xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    XML

    urls.each do |entry|
      xml << "  <url>\n"
      xml << "    <loc>#{entry[:loc]}</loc>\n"
      xml << "    <lastmod>#{entry[:lastmod]}</lastmod>\n" if entry[:lastmod]
      xml << "    <changefreq>#{entry[:changefreq]}</changefreq>\n" if entry[:changefreq]
      xml << "    <priority>#{entry[:priority]}</priority>\n" if entry[:priority]
      xml << "  </url>\n"
    end

    xml << "</urlset>\n"

    sitemap_path = Rails.root.join("public", "sitemap.xml")
    File.write(sitemap_path, xml)

    puts "Sitemap generated at #{sitemap_path} with #{urls.size} URL(s)"
  end
end
