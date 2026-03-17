module SeoHelper
  def meta_title(title = nil)
    content_for(:title, title ? "#{title} | RailsyCommerce" : "RailsyCommerce")
  end

  def meta_description(description)
    content_for(:meta_description, description)
  end

  def og_image(url)
    content_for(:og_image, url)
  end

  def product_json_ld(product)
    variant = product.master_variant
    return "" unless variant

    data = {
      "@context" => "https://schema.org",
      "@type" => "Product",
      "name" => product.name,
      "description" => product.description,
      "sku" => variant.sku,
      "url" => product_url(product),
      "offers" => {
        "@type" => "Offer",
        "priceCurrency" => "USD",
        "price" => (variant.price_cents / 100.0).to_s,
        "availability" => product.in_stock? ? "https://schema.org/InStock" : "https://schema.org/OutOfStock"
      }
    }

    if product.images.attached?
      data["image"] = url_for(product.images.first)
    end

    if product.reviews_count > 0 && product.average_rating
      data["aggregateRating"] = {
        "@type" => "AggregateRating",
        "ratingValue" => product.average_rating.to_s,
        "reviewCount" => product.reviews_count.to_s
      }
    end

    tag.script(data.to_json.html_safe, type: "application/ld+json")
  end
end
