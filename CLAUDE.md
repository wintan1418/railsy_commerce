# RailsyCommerce - Development Conventions

## Project Overview
Rails 8 e-commerce template kit. Clean, fast, simple alternative to Spree/Solidus.

## Tech Stack
- Rails 8.0.4, Ruby 3.4.3, PostgreSQL
- Hotwire (Turbo + Stimulus), Tailwind CSS 4, esbuild
- Solid Queue, Solid Cache, Solid Cable (no Redis)
- Kamal for deployment, Stripe for payments

## Architecture Rules

### Code Organization
- **Service Objects**: `app/services/` using `VerbNounService` naming. Each inherits `ApplicationService` and returns `ServiceResult`.
- **ViewComponents**: `app/components/` with `*Component` naming.
- **Controllers**: Admin namespace `Admin::`, Storefront `Storefront::`, Account `Account::`, Webhooks `Webhooks::`.
- **No Rails engines**. No mountable gems. Users own all code directly.

### Database
- Prices stored as integer cents via `money-rails` (`price_cents`, `total_cents`).
- All foreign keys must be indexed.
- Slugs via `friendly_id` for SEO-friendly URLs.
- String enums for status fields (not integer enums). No state machine gems.

### Auth
- Use Rails 8 built-in authentication. No Devise.
- Admin access via `role` enum on User model + `require_admin` concern.

## Testing
- **Every feature gets tests**: model, controller/request, and system tests.
- Use fixtures (YAML), not factories.
- Run `bin/rails test` before every commit.
- System tests use headless Chrome via Selenium.

## Code Style
- Follow `rubocop-rails-omakase` style guide.
- Run `bundle exec rubocop` before commits.
- Run `bundle exec brakeman` for security checks.

## Commit Conventions
- Conventional commits: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`
- Co-authored with Claude.
- Commit after each meaningful, testable unit of work.

## Commands
- `bin/rails test` - Run all tests
- `bin/rails test:system` - Run system tests
- `bundle exec rubocop` - Lint check
- `bundle exec brakeman` - Security scan
- `bin/dev` - Start development server (web + js + css watchers)
- `bin/rails db:seed` - Seed development data

## Key Patterns
- **Master Variant**: Every product has at least one "master" variant. Price always lives on variant.
- **Inventory**: `available_quantity` / `reserved_quantity` split on StockItem. Prevents overselling.
- **Cart**: Session-based via token cookie. Works for guests and authenticated users.
- **Order Items**: Snapshot `unit_price_cents` at purchase time. Future price changes don't affect history.
