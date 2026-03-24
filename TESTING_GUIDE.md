# RailsyCommerce Testing Guide

## Login Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@railsycommerce.com | password |
| Customer | customer@example.com | password |

---

## Storefront Testing

### Home Page → `localhost:8000`
- Hero slideshow should auto-rotate every 4.5 seconds
- "Popular Right Now" products visible immediately below trust bar
- Category cards → click one → shows all products in that category
- "New Arrivals" section with 16 products
- "On Sale" section with discounted products
- Newsletter signup form at bottom

### Products → `localhost:8000/products`
- Click category tabs on the left to filter
- Use sort dropdown (Newest, Price Low-High, Price High-Low)
- Toggle "On Sale" filter
- Click a product → detail page with images, variants, reviews, add to cart

### Add to Cart
1. On any product, click **"Add to Cart"**
2. Gold toast notification appears top-right: "Added to cart!"
3. Cart badge in header updates with item count
4. Click cart icon → see cart with items, quantities, subtotal
5. Adjust quantities with +/- buttons
6. Click **"Proceed to Checkout"**

### Wishlist (requires sign-in)
1. Sign in as customer
2. Click the heart icon on any product card or product detail page
3. Toast: "Added to wishlist!"
4. Click heart again → "Removed from wishlist."
5. View wishlist at `localhost:8000/account/wishlist`
6. Add items to cart directly from wishlist

### Track Order → Click "Track Order" in nav
1. Go to `localhost:8000/track`
2. Enter any order number (check admin orders page for real numbers)
3. See the visual progress bar and timeline
4. Order summary shown at bottom

---

## Checkout Testing

1. Add 1-2 products to cart
2. Go to cart → click **"Proceed to Checkout"**
3. **Step 1 - Address**: Fill shipping address form → click Continue
4. **Step 2 - Shipping**: Select a shipping method (Standard/Express/Free) → click Continue
5. **Step 3 - Payment**: Review order → click **"Pay & Place Order"**
6. See order confirmation page with order number
7. Check email (letter_opener in dev, or check logs in production)

---

## Customer Account Pages

Sign in as customer first (`customer@example.com` / `password`)

| Page | URL | What to Test |
|------|-----|-------------|
| Order History | `localhost:8000/account` | View past orders, click for details |
| Wishlist | `localhost:8000/account/wishlist` | View saved items, add to cart, remove |
| Addresses | `localhost:8000/account/addresses` | Add/edit/delete shipping addresses |
| Profile | `localhost:8000/account/profile` | Update name, email |

---

## Admin Panel

Sign in as admin (`admin@railsycommerce.com` / `password`) → `localhost:8000/admin`

| Section | What to Test |
|---------|-------------|
| **Dashboard** | Revenue stats, order count, top products, low stock alerts |
| **Orders** | List orders, filter by status, click order → update status, view timeline |
| **Customers** | Search customers, view profiles with order history and spend |
| **Products** | Create/edit/delete products, upload images, set pricing |
| **Categories** | Create/edit/delete, set parent categories, toggle active |
| **Inventory** | View stock levels, adjust quantities, see low stock warnings |
| **Shipping** | Create/edit shipping methods with pricing and delivery estimates |
| **Discounts** | Create coupon codes (percentage or fixed), set usage limits and dates |
| **Promotions** | Create auto-apply promotions (free shipping, category discounts) |
| **Tax Rates** | Create tax rates by country/state |
| **Reviews** | Approve/reject/delete customer reviews |
| **Returns** | View return requests, approve/reject/refund |
| **Pages** | Edit CMS pages (About Us, FAQ, Contact, etc.) |
| **Appearance** | Change colors, hero text, social links, announcement bar |
| **Settings** | Store name, currency, contact email, free shipping threshold |

### Admin CSV Export
- Go to Orders → add `.csv` to the URL: `localhost:8000/admin/orders.csv`
- Downloads all orders as CSV

---

## Vendor Testing

### Register as Vendor
1. Go to `localhost:8000/registration/new`
2. Select **"Sell"** (right card)
3. Business name and phone fields appear
4. Fill all fields → click **"Create account"**
5. Gold store icon appears in header nav

### Vendor Dashboard → `localhost:8000/vendor`
| Section | What to Test |
|---------|-------------|
| Dashboard | Revenue, product count, order count |
| My Products | Add/edit/delete your products |
| Orders | View orders containing your products |
| Tracking | Add delivery updates to orders |

### Adding Delivery Tracking (Vendor)
1. Go to `localhost:8000/vendor/orders`
2. Click **"Track & Update"** on any order
3. Select status (e.g., "In Transit")
4. Enter location (e.g., "Lagos Sorting Center")
5. Enter description (e.g., "Package has left warehouse")
6. Optionally add tracking number and estimated delivery
7. Click **"Add Update"**
8. Timeline updates immediately

### Verify Tracking (Customer side)
1. Copy the order number from vendor order page
2. Go to `localhost:8000/track`
3. Paste the order number → click Track
4. See the progress bar and all tracking updates

---

## Google Sign-In Testing
1. Go to login or registration page
2. Click **"Continue with Google"**
3. Select your Google account
4. Redirected back signed in
5. If existing email matches → accounts are linked

**Note:** Google OAuth requires `http://localhost:8000/auth/google_oauth2/callback` as an authorized redirect URI in Google Cloud Console.

---

## PWA Testing (Mobile App Feel)

### iOS
1. Open `your-domain.com` in Safari
2. Tap Share button (square with arrow)
3. Tap **"Add to Home Screen"**
4. Tap **"Add"**
5. Open from home screen → runs fullscreen, no browser chrome

### Android
1. Open `your-domain.com` in Chrome
2. Tap three-dot menu
3. Tap **"Add to Home Screen"** or **"Install App"**
4. Open from home screen → runs as standalone app

### Offline Test
1. Install PWA as above
2. Load the home page and products page
3. Turn off WiFi/data
4. Open the app → cached pages still load

---

## API Testing

### Public Endpoints (no auth needed)

```bash
# List all products (paginated)
curl http://localhost:8000/api/v1/products

# Search products
curl "http://localhost:8000/api/v1/products?q=solar"

# Filter by category
curl "http://localhost:8000/api/v1/products?category_id=1"

# Single product with variants
curl http://localhost:8000/api/v1/products/1
```

### Authenticated Endpoints

Get your session ID from browser cookies (look for `session_id` cookie value).

```bash
# List your orders
curl -H "Authorization: Bearer YOUR_SESSION_ID" \
  http://localhost:8000/api/v1/orders

# View specific order
curl -H "Authorization: Bearer YOUR_SESSION_ID" \
  http://localhost:8000/api/v1/orders/1

# View cart
curl -H "Authorization: Bearer YOUR_SESSION_ID" \
  http://localhost:8000/api/v1/cart

# Add to cart
curl -X POST -H "Authorization: Bearer YOUR_SESSION_ID" \
  -H "Content-Type: application/json" \
  -d '{"variant_id": 1, "quantity": 2}' \
  http://localhost:8000/api/v1/cart/add_item
```

---

## Static Pages

| Page | URL |
|------|-----|
| About Us | `localhost:8000/about-us` |
| Contact | `localhost:8000/contact` |
| FAQ | `localhost:8000/faq` |
| Shipping Policy | `localhost:8000/shipping-policy` |
| Return Policy | `localhost:8000/return-policy` |
| Hire a Developer | `localhost:8000/hire` |

---

## Running Automated Tests

```bash
# All tests (275 tests)
bin/rails test

# Just model tests
bin/rails test test/models/

# Just controller tests
bin/rails test test/controllers/

# Just service tests
bin/rails test test/services/

# System tests (browser)
bin/rails test:system

# Single test file
bin/rails test test/models/product_test.rb

# With verbose output
bin/rails test -v
```

---

## Quick Smoke Test Checklist

- [ ] Home page loads with products and categories
- [ ] Can browse products and filter by category
- [ ] Can view a product detail page
- [ ] Can add to cart (toast appears)
- [ ] Can view cart with correct items and totals
- [ ] Can proceed through checkout
- [ ] Can sign up as customer
- [ ] Can sign up as vendor
- [ ] Can sign in / sign out
- [ ] Can add/remove wishlist items
- [ ] Can track an order
- [ ] Admin dashboard loads with stats
- [ ] Admin can manage products/orders/categories
- [ ] Vendor can manage their products
- [ ] Vendor can add tracking updates
- [ ] Mobile: pages are responsive, no horizontal scroll
- [ ] Mobile: PWA installs and opens fullscreen
- [ ] Google sign-in works (if configured)
