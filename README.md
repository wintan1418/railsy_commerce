# RailsyCommerce

A production-ready e-commerce template kit built with **Rails 8**, **Hotwire**, and **Tailwind CSS 4**. Designed for developers selling to clients and non-technical business owners who want a beautiful, functional online store out of the box.

Features a luxury editorial aesthetic with Cormorant Garamond and DM Sans typography, gold accent tones, and a refined shopping experience.

---

## Table of Contents

- [Features](#features)
- [Quick Start (5 Minutes)](#quick-start-5-minutes)
- [Configuration Guide](#configuration-guide)
- [Deployment Guide](#deployment-guide)
- [Non-Technical Owner Guide](#non-technical-owner-guide)
- [Developer Customization Guide](#developer-customization-guide)
- [API Documentation](#api-documentation)
- [License](#license)

---

## Features

- **Storefront** -- Product catalog with search (pg_search), categories, filtering, and variant selection
- **Cart & Checkout** -- Multi-step checkout flow with address, shipping, and payment steps via Turbo Frames
- **Customer Accounts** -- Registration, login (email + Google OAuth), password reset, order history, saved addresses, wishlists
- **Admin Dashboard** -- Full back-office for products, orders, categories, reviews, discounts, promotions, and settings
- **Theme Customization** -- Admin CMS for colors, hero section, header, footer, and social media links (no code needed)
- **Setup Wizard** -- Guided onboarding for new store owners (store basics, payment, shipping, appearance)
- **Order Management** -- Service-object-driven order creation, email confirmations, shipment tracking
- **Inventory Tracking** -- Stock items per variant with reservation and release logic
- **Returns Management** -- Customer return requests with admin review workflow
- **Reviews & Ratings** -- Moderated product reviews with star ratings
- **Discounts** -- Coupon code system with flexible discount rules
- **Promotions** -- Auto-applied promotions (free shipping, percentage off categories)
- **Tax Calculation** -- Address-based tax rate lookups
- **CMS Pages** -- Admin-managed static pages (About, FAQ, Shipping Policy, etc.)
- **Hire Me Page** -- Built-in professional services landing page for developers
- **Email Notifications** -- Order confirmation, shipping updates, welcome emails (via Brevo)
- **Background Jobs** -- Abandoned cart expiration with stock release (Solid Queue)
- **Sitemap Generation** -- Rake task for SEO-friendly sitemap.xml
- **API** -- RESTful JSON API with Bearer token authentication for products, orders, and cart
- **Responsive Design** -- Mobile-first layout with luxury design system (CSS custom properties)
- **Deployment Ready** -- Kamal configuration included, guides for Railway, Render, DigitalOcean, Heroku

---

## Quick Start (5 Minutes)

### Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Ruby | 3.4.3+ | `rbenv install 3.4.3` or [ruby-lang.org](https://www.ruby-lang.org/) |
| Node.js | 20+ | [nodejs.org](https://nodejs.org/) or `nvm install 20` |
| Yarn | 1.22+ | `npm install -g yarn` |
| PostgreSQL | 15+ | [postgresql.org](https://www.postgresql.org/download/) |
| Redis | 7+ | [redis.io](https://redis.io/) (for Action Cable & Solid Queue) |

### Setup

```bash
# Clone the repository
git clone https://github.com/your-org/railsy_commerce.git
cd railsy_commerce

# Copy environment file
cp .env.example .env

# Run automated setup (installs deps, creates DB, seeds, runs tests)
bin/setup --skip-server

# Or do it manually:
bundle install
yarn install
bin/rails db:create db:migrate db:seed

# Start the development server
bin/dev
```

The app will be available at **http://localhost:3000**.

### Default Credentials

| Role | Email | Password |
|------|-------|----------|
| **Admin** | `admin@railsycommerce.com` | `password` |
| **Customer** | `customer@example.com` | `password` |

### Key URLs

| Page | URL |
|------|-----|
| Storefront | http://localhost:3000 |
| Admin Panel | http://localhost:3000/admin |
| Setup Wizard | http://localhost:3000/admin/setup |
| Hire Page | http://localhost:3000/hire |

---

## Configuration Guide

### Environment Variables

Copy `.env.example` to `.env` and fill in your values. Here is every variable explained:

| Variable | Required | Description |
|----------|----------|-------------|
| `STRIPE_PUBLISHABLE_KEY` | For payments | Stripe publishable key from [dashboard.stripe.com/apikeys](https://dashboard.stripe.com/apikeys) |
| `STRIPE_SECRET_KEY` | For payments | Stripe secret key |
| `PAYSTACK_SECRET_KEY` | Optional | Paystack secret key (alternative payment gateway) |
| `PAYSTACK_PUBLIC_KEY` | Optional | Paystack public key |
| `GOOGLE_CLIENT_ID` | For OAuth | Google OAuth client ID from [Cloud Console](https://console.cloud.google.com/apis/credentials) |
| `GOOGLE_CLIENT_SECRET` | For OAuth | Google OAuth client secret |
| `BREVO_SMTP_USERNAME` | For emails | Brevo (formerly Sendinblue) SMTP username |
| `BREVO_SMTP_PASSWORD` | For emails | Brevo SMTP password |
| `OPENAI_API_KEY` | Optional | OpenAI API key for AI features |
| `ANTHROPIC_API_KEY` | Optional | Anthropic API key for AI features |
| `GOOGLE_API_KEY` | Optional | Google AI API key |
| `DATABASE_URL` | Production | PostgreSQL connection string |
| `REDIS_URL` | Production | Redis connection string |
| `SECRET_KEY_BASE` | Production | Generate with `bin/rails secret` |

### Store Settings via Admin Panel

1. Log in to `/admin` with your admin account
2. Go to **Settings** to configure:
   - Store name, contact email, currency
   - Free shipping threshold
3. Go to **Appearance** to customize:
   - Colors (primary, secondary, accent)
   - Hero section (headline, subtext, CTA button)
   - Header (announcement bar, search bar visibility)
   - Footer (tagline, copyright, newsletter toggle)
   - Social media links (Instagram, Twitter/X, Facebook, TikTok, YouTube, LinkedIn)

### Payment Setup (Stripe)

1. Create an account at [stripe.com](https://stripe.com)
2. Go to [Developers > API keys](https://dashboard.stripe.com/apikeys)
3. Copy your **Publishable key** (starts with `pk_test_`) and **Secret key** (starts with `sk_test_`)
4. Add them to your `.env` file
5. For production, toggle to "Live" mode in Stripe and use live keys
6. Set up a webhook endpoint at `https://yourdomain.com/webhooks/stripe` for events:
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`

### Email Setup (Brevo)

1. Sign up at [brevo.com](https://www.brevo.com/) (free tier: 300 emails/day)
2. Go to Settings > SMTP & API > SMTP
3. Copy your SMTP login and password
4. Add `BREVO_SMTP_USERNAME` and `BREVO_SMTP_PASSWORD` to `.env`
5. Verify your sending domain in Brevo for production deliverability

### Google OAuth Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or select an existing one)
3. Navigate to **APIs & Services > Credentials**
4. Click **Create Credentials > OAuth client ID**
5. Select "Web application"
6. Add authorized redirect URIs:
   - Development: `http://localhost:3000/auth/google_oauth2/callback`
   - Production: `https://yourdomain.com/auth/google_oauth2/callback`
7. Copy the Client ID and Client Secret to your `.env`

---

## Deployment Guide

### Option 1: Kamal (Recommended -- Built-in)

Kamal is included and configured. Deploy to any VPS (DigitalOcean, Hetzner, AWS EC2, etc.).

**Prerequisites:** A server with Docker installed, a container registry (Docker Hub or GitHub Container Registry).

```bash
# 1. Configure your server and registry
#    Edit config/deploy.yml with your server IP and registry details

# 2. Set secrets
#    Edit .kamal/secrets with your production environment variables

# 3. Initial setup (first time only)
kamal setup

# 4. Deploy
kamal deploy

# 5. Run migrations
kamal app exec 'bin/rails db:migrate'

# 6. Seed the database (first time only)
kamal app exec 'bin/rails db:seed'

# 7. Check logs
kamal app logs

# 8. Open a Rails console
kamal app exec -i 'bin/rails console'
```

### Option 2: Railway (Simple PaaS)

[Railway](https://railway.app) is the easiest deployment option.

```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Initialize project
railway init

# 4. Add PostgreSQL
railway add -p postgresql

# 5. Add Redis
railway add -p redis

# 6. Set environment variables
railway variables set STRIPE_PUBLISHABLE_KEY=pk_live_xxx
railway variables set STRIPE_SECRET_KEY=sk_live_xxx
railway variables set SECRET_KEY_BASE=$(bin/rails secret)
railway variables set RAILS_SERVE_STATIC_FILES=true
# ... add remaining env vars

# 7. Deploy
railway up

# 8. Run migrations
railway run bin/rails db:migrate

# 9. Seed database
railway run bin/rails db:seed
```

### Option 3: Render

1. Create an account at [render.com](https://render.com)
2. Click **New > Web Service**
3. Connect your GitHub repository
4. Configure:
   - **Build Command:** `bundle install && yarn install && bin/rails assets:precompile`
   - **Start Command:** `bin/rails server -p $PORT`
5. Add a **PostgreSQL** database from the Render dashboard
6. Set environment variables in the Render dashboard:
   ```
   DATABASE_URL        = (auto-set by Render when you link the database)
   SECRET_KEY_BASE     = (generate with: bin/rails secret)
   RAILS_SERVE_STATIC_FILES = true
   RAILS_LOG_LEVEL     = info
   STRIPE_PUBLISHABLE_KEY = pk_live_xxx
   STRIPE_SECRET_KEY   = sk_live_xxx
   BREVO_SMTP_USERNAME = xxx
   BREVO_SMTP_PASSWORD = xxx
   ```
7. After first deploy, open the **Shell** tab and run:
   ```bash
   bin/rails db:migrate
   bin/rails db:seed
   ```

### Option 4: DigitalOcean App Platform

1. Create an account at [digitalocean.com](https://www.digitalocean.com/)
2. Go to **App Platform > Create App**
3. Connect your GitHub repository
4. Add a **Dev Database** (PostgreSQL) component
5. Set the run command: `bin/rails server -p $PORT`
6. Set the build command: `bundle install && yarn install && bin/rails assets:precompile`
7. Add environment variables (same as Render above)
8. Deploy. After deployment, use the **Console** to run:
   ```bash
   bin/rails db:migrate
   bin/rails db:seed
   ```

### Option 5: Heroku

```bash
# 1. Install Heroku CLI
# https://devcenter.heroku.com/articles/heroku-cli

# 2. Login
heroku login

# 3. Create app
heroku create your-store-name

# 4. Add PostgreSQL
heroku addons:create heroku-postgresql:essential-0

# 5. Add Redis
heroku addons:create heroku-redis:mini

# 6. Set environment variables
heroku config:set SECRET_KEY_BASE=$(bin/rails secret)
heroku config:set RAILS_SERVE_STATIC_FILES=true
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_live_xxx
heroku config:set STRIPE_SECRET_KEY=sk_live_xxx
heroku config:set BREVO_SMTP_USERNAME=xxx
heroku config:set BREVO_SMTP_PASSWORD=xxx
# ... add remaining env vars

# 7. Deploy
git push heroku main

# 8. Run migrations and seed
heroku run bin/rails db:migrate
heroku run bin/rails db:seed

# 9. Open your store
heroku open
```

---

## Non-Technical Owner Guide

This section is for store owners who want to manage their store without touching code.

### How to Manage Products

1. Log in to the admin panel at `/admin`
2. Click **Products** in the sidebar
3. To add a product:
   - Click **New Product**
   - Fill in the name, description, and select a category
   - Add product images (drag and drop or click to upload)
   - Set the price and compare-at price (for sale items)
   - Add variants if the product comes in different sizes/colors
   - Set the status to "Active" to make it visible
   - Click **Save**
4. To edit a product, click its name in the products list
5. To manage stock, go to **Inventory** in the sidebar

### How to Process Orders

1. Go to **Orders** in the admin sidebar
2. New orders appear with status "Pending"
3. Click an order to view details
4. Update the status as you process it:
   - **Confirmed** -- You've acknowledged the order
   - **Processing** -- You're preparing the order
   - **Shipped** -- The order has been shipped (customer gets an email)
   - **Delivered** -- The order has been delivered
5. The customer can see status updates in their account

### How to Manage Customers

1. Go to **Customers** in the admin sidebar
2. View all registered customers, their order count, and total spent
3. Click a customer to see their profile and order history

### How to Create Discount Codes

1. Go to **Discounts** in the admin sidebar
2. Click **New Discount**
3. Set a coupon code (e.g., `SAVE20`)
4. Choose the discount type (percentage or fixed amount)
5. Set conditions (minimum order amount, expiry date, usage limit)
6. Click **Save**
7. Share the code with your customers

### How to Edit Pages (About, FAQ, etc.)

1. Go to **Pages** in the admin sidebar
2. Click a page to edit its content
3. Update the title and body text
4. Toggle "Published" to show/hide the page
5. Click **Save**
6. Pages are accessible at `yourdomain.com/page-slug`

### How to Customize Appearance

1. Go to **Appearance** in the admin sidebar
2. Customize each section:
   - **General**: Store name, tagline, logo
   - **Colors**: Primary color (buttons/accents), secondary color, accent color
   - **Hero**: Homepage headline, subtext, call-to-action button text and link
   - **Header**: Announcement bar text, toggle search bar
   - **Footer**: Footer tagline, copyright text, newsletter toggle
   - **Social Media**: Add links to your Instagram, Twitter, Facebook, etc.
3. Click **Save Appearance**

### How to Add Shipping Methods

1. Go to **Shipping** in the admin sidebar
2. Click **New Shipping Method**
3. Set the name (e.g., "Express Shipping"), price, and delivery time estimate
4. Toggle "Active" to enable it
5. Click **Save**

### How to Set Up Tax Rates

1. Go to **Tax Rates** in the admin sidebar
2. Click **New Tax Rate**
3. Set the region/state, tax percentage, and name
4. Click **Save**
5. Tax is automatically calculated at checkout based on the shipping address

---

## Developer Customization Guide

### Architecture Overview

```
app/
  controllers/
    admin/           # Admin panel controllers
    storefront/      # Customer-facing controllers
    api/v1/          # JSON API controllers
    account/         # Customer account controllers
    webhooks/        # Webhook handlers (Stripe)
  models/            # ActiveRecord models
  services/          # Service objects (business logic)
  views/
    admin/           # Admin panel views
    storefront/      # Product listings, categories
    pages/           # Static pages (home, hire, etc.)
    shared/          # Header, footer partials
    layouts/         # Application, admin, checkout layouts
  jobs/              # Background jobs (Solid Queue)
  mailers/           # Email templates
```

### Service Object Pattern

All business logic lives in `app/services/` and follows a consistent pattern:

```ruby
# app/services/application_service.rb -- base class
class ApplicationService
  def self.call(**args)
    new(**args).call
  end

  # Returns a ServiceResult with .success?, .payload, .errors
end

# Usage:
result = Orders::CreateOrderService.call(cart: cart, email: email, ...)
if result.success?
  order = result.payload[:order]
else
  errors = result.errors
end
```

Key services:
- `Orders::CreateOrderService` -- Builds an order from a cart
- `Tax::CalculateTaxService` -- Computes tax based on shipping address
- `Inventory::ReserveStockService` / `ReleaseStockService` -- Stock management
- `Payments::ProcessRefundService` -- Handles payment refunds
- `Discounts::ApplyDiscountService` -- Applies coupon codes
- `Promotions::ApplyPromotionsService` -- Auto-applies active promotions
- `Analytics::DashboardService` -- Computes admin dashboard metrics
- `Products::FilterService` -- Search and filter products

### How to Add a New Payment Provider

1. Create a new service: `app/services/payments/your_provider_service.rb`
2. Implement `call` method that creates a payment intent/session
3. Add a webhook controller: `app/controllers/webhooks/your_provider_controller.rb`
4. Add the route in `config/routes.rb` under the webhooks namespace
5. Update the checkout view to include the provider's payment form
6. Add the provider's API gem to the Gemfile

### How to Add a New Shipping Carrier

1. Create a service: `app/services/shipping/your_carrier_service.rb`
2. Implement rate calculation and tracking lookup
3. Add carrier-specific fields to the ShippingMethod model if needed (via migration)
4. Update the checkout shipping step to show carrier-specific options

### How to Customize the Theme

**CSS Custom Properties** (in your Tailwind CSS file):

```css
:root {
  --gold: #c9a96e;       /* Primary accent */
  --gold-light: #d4b97e; /* Lighter accent */
  --black: #1a1a1a;      /* Dark backgrounds/text */
  --cream: #faf9f6;      /* Light backgrounds */
  --warm-gray: #e8e5e0;  /* Borders and subtle backgrounds */
  --warm-white: #fdfcfa;
  --mid-gray: #8a8578;   /* Secondary text */
  --red: #c0392b;        /* Sale/error */
}
```

**Fonts**: Update the Google Fonts import in `app/views/layouts/application.html.erb` and the `.font-display` class in your CSS.

**Layout**: Admin uses `app/views/layouts/admin.html.erb`. Storefront uses `app/views/layouts/application.html.erb`. Checkout has its own `app/views/layouts/checkout.html.erb`.

### How to Add New Admin Sections

1. Create a controller in `app/controllers/admin/` that inherits from `Admin::BaseController`
2. Create views in `app/views/admin/your_section/`
3. Add routes in `config/routes.rb` under the `admin` namespace
4. Add a sidebar link in `app/views/layouts/admin.html.erb`
5. Follow the existing card-based design pattern (rounded-xl, ring-1 ring-gray-900/5)

### Testing Guide

```bash
# Run all tests
bin/rails test

# Run a specific test file
bin/rails test test/models/theme_setting_test.rb

# Run a specific test by line number
bin/rails test test/models/theme_setting_test.rb:10

# Run model tests
bin/rails test test/models/

# Run controller tests
bin/rails test test/controllers/

# Run system tests
bin/rails test:system
```

---

## API Documentation

The API uses **Bearer token authentication**. Pass the token in the `Authorization` header.

### Authentication

```
Authorization: Bearer <user_api_token>
```

### Products

**List all products**
```http
GET /api/v1/products
```

Response:
```json
{
  "products": [
    {
      "id": 1,
      "name": "Essential Cotton Crew Tee",
      "slug": "essential-cotton-crew-tee",
      "description": "...",
      "category": "T-Shirts",
      "status": "active",
      "variants": [
        {
          "id": 1,
          "sku": "RC-0001-MST",
          "price": "$39.00",
          "price_cents": 3900,
          "in_stock": true
        }
      ]
    }
  ]
}
```

**Get a single product**
```http
GET /api/v1/products/:id
```

### Orders

**List orders** (authenticated)
```http
GET /api/v1/orders
Authorization: Bearer <token>
```

Response:
```json
{
  "orders": [
    {
      "id": 1,
      "number": "RC-00001",
      "status": "delivered",
      "total_cents": 12800,
      "items_count": 3,
      "created_at": "2026-03-15T10:30:00Z"
    }
  ]
}
```

**Get a single order** (authenticated)
```http
GET /api/v1/orders/:id
Authorization: Bearer <token>
```

### Cart

**View cart**
```http
GET /api/v1/cart
```

**Add item to cart**
```http
POST /api/v1/cart/add_item
Content-Type: application/json

{
  "variant_id": 1,
  "quantity": 2
}
```

**Update item quantity**
```http
PATCH /api/v1/cart/update_item
Content-Type: application/json

{
  "variant_id": 1,
  "quantity": 3
}
```

**Remove item from cart**
```http
DELETE /api/v1/cart/remove_item
Content-Type: application/json

{
  "variant_id": 1
}
```

---

## License

[Your license here]
