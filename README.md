# RailsyCommerce

A production-ready e-commerce template built with Rails 8, Hotwire, and Tailwind CSS 4. Designed with a luxury editorial aesthetic featuring Cormorant Garamond and DM Sans typography, gold accent tones, and a refined shopping experience.

## Features

- **Storefront** -- Product catalog with search (pg_search), categories, filtering, and variant selection
- **Cart & Checkout** -- Multi-step checkout flow with address, shipping, and payment steps via Turbo Frames
- **Customer Accounts** -- Registration, login, password reset, order history, saved addresses, wishlists
- **Admin Dashboard** -- Full back-office for products, orders, categories, reviews, discounts, and settings
- **Order Management** -- Service-object-driven order creation, email confirmations, shipment tracking
- **Inventory Tracking** -- Stock items per variant with reservation and release logic
- **Reviews & Ratings** -- Moderated product reviews with star ratings
- **Discounts** -- Coupon code system with flexible discount rules
- **Tax Calculation** -- Address-based tax rate lookups
- **Email Notifications** -- Order confirmation, shipping updates, welcome emails
- **Background Jobs** -- Abandoned cart expiration with stock release
- **Sitemap Generation** -- Rake task for SEO-friendly sitemap.xml
- **Responsive Design** -- Mobile-first layout with luxury design system (CSS custom properties)
- **Deployment Ready** -- Kamal configuration included

## Quick Start

### Requirements

- Ruby 3.4.3
- Node.js 20.x
- PostgreSQL 15+
- Redis (for Action Cable and Solid Queue)
- Yarn

### Setup

```bash
# Clone the repository
git clone https://github.com/your-org/railsy_commerce.git
cd railsy_commerce

# Install dependencies
bundle install
yarn install

# Set up the database
bin/rails db:create db:migrate db:seed

# Start the development server
bin/dev
```

The app will be available at `http://localhost:3000`.

### Admin Credentials

After seeding, log in to the admin panel at `/admin` with:

```
Email:    admin@railsycommerce.com
Password: password
```

## Architecture

### Service Objects

Business logic lives in `app/services/` following a consistent pattern:

```ruby
# All services inherit from ApplicationService
result = Orders::CreateOrderService.call(cart: cart, email: email, ...)

result.success?        # => true / false
result.payload[:order] # => the created order
result.errors          # => array of error messages
```

Key services:
- `Orders::CreateOrderService` -- Builds an order from a cart
- `Tax::CalculateTaxService` -- Computes tax based on shipping address
- `Inventory::ReserveStockService` / `Inventory::ReleaseStockService` -- Stock management
- `Payments::ProcessRefundService` -- Handles payment refunds

### Models

Core models: `Product`, `Variant`, `Category`, `Cart`, `Order`, `OrderItem`, `Address`, `ShippingMethod`, `Shipment`, `User`, `Review`, `Discount`

Products use the `friendly_id` gem for slugged URLs. Variants support option types/values for product attributes (size, color, etc.). Money fields use `money-rails` for currency handling.

### Frontend

- **Tailwind CSS 4** with CSS custom properties for theming (`--gold`, `--black`, `--cream`, `--warm-gray`, etc.)
- **Hotwire** (Turbo + Stimulus) for SPA-like interactions without JavaScript complexity
- **Cormorant Garamond** for display headings (`.font-display` class)
- **DM Sans** for body text
- Gold accent color: `#c9a96e`

### Background Jobs

Jobs are processed via Solid Queue:

- `ExpireAbandonedCartsJob` -- Cleans up carts inactive for 24+ hours and releases reserved stock

### Mailers

- `OrderMailer` -- Confirmation and shipped notifications
- `UserMailer` -- Welcome email on registration
- `PasswordsMailer` -- Password reset instructions

## Deployment with Kamal

The project includes a Kamal configuration in `.kamal/`. To deploy:

```bash
# Initial setup
kamal setup

# Deploy
kamal deploy

# Run database migrations on the server
kamal app exec 'bin/rails db:migrate'
```

Configure your server details in `config/deploy.yml` and set environment variables via `.kamal/secrets`.

## Customization

### Changing the Color Palette

Edit the CSS custom properties in your Tailwind CSS file:

```css
:root {
  --gold: #c9a96e;
  --gold-light: #d4b97e;
  --black: #1a1a1a;
  --cream: #faf9f6;
  --warm-gray: #e8e5e0;
  --white: #ffffff;
}
```

### Changing Fonts

Update the Google Fonts import in `app/views/layouts/application.html.erb` and adjust the `font-display` CSS class accordingly.

### Adding New Product Option Types

1. Create option types in the admin panel (e.g., "Material", "Length")
2. Associate them with products
3. Create variants with option value combinations

### Adding a Payment Gateway

The checkout flow includes a Stripe Elements placeholder. To integrate:

1. Add `stripe` gem to your Gemfile
2. Create `app/services/payments/create_payment_intent_service.rb`
3. Add Stripe.js to the payment step
4. Handle webhook events in `app/controllers/webhooks/stripe_controller.rb`

### Generating the Sitemap

```bash
bin/rails sitemap:generate
```

This creates `public/sitemap.xml` with all products and categories.

## License

[Your license here]
