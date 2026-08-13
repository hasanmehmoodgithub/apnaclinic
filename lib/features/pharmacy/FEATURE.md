# Pharmacy feature

## Purpose

Browse medicines, cart, checkout, and view pharmacy order details.

## Data & APIs

| Action | Method | `AppUrls` | Body |
|--------|--------|-----------|------|
| List products | POST | `pharmacyProducts` → `acs-aggregator/api/v1/mobile/partner/pharmacy/products` | `{ "page": "1", "display_name": "" }` — pass search text in `display_name` when searching; empty for browse |
| Product detail | POST | `pharmacyProductDetail` → `acs-aggregator/api/v1/mobile/partner/pharmacy/product/details` | `{ "product_id": <id>, "similar_items": true }` — product fields in `data` (`product_id`, `display_name`, `image_url`, `price`, `manufacturer`, `category`, `prescription_required`, `generic_name`, `package_type`, `indications`, `contra_indications`, `images[]`); `data.similar_items[]` for “More like” (legacy `related_items` still parsed) |
| Cart (active) | POST | `pharmacyCart` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/active` | `{}` — cart in `data` or `data.data`: `products[]`, `booking_id` / `booking.id`, `payment_breakdown`, `family_members[].addresses` |
| Add to cart | POST | `pharmacyAddToCart` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/add` | `{ "product_id": <id>, "quantity": <n> }` — both **int**; on success, update local cart/`cartBookingId` from response (no active-cart refetch) |
| Update cart qty | POST | `pharmacyUpdateCartQuantity` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/quantity/update` | `{ "product_id": <id>, "quantity": <n> }` — both **int**; on success, update local cart from response (no active-cart refetch) |
| Order checkout | POST | `pharmacyOrderCheckout` → `…/pharmacy/order/checkout` | JWT `PartnerCheckoutDto`: `{ "user_location_id", "payment_method" (`COD` / `JAZZCASH` / `CARD`), "prescriptions"?, "jazz_cash_number"? (digits 10–15, required for JazzCash), "delivery_instructions"?, "name"? }`. Logged-in checkout sends `user_location_id` + `payment_method` + `prescriptions` + `jazz_cash_number` (JazzCash, `92…`) + `delivery_instructions` (special instructions, max 500). Do **not** send guest_* fields or `msisdn`. `name` only if profile has no name (not collected yet). `prescriptions` empty until Rx upload URLs exist |
| List addresses | POST | `pharmacyProfileAddressesList` → `…/pharmacy/profile/addresses/list` | `{}` — `data[]`: `address_id`, `label`, `recipient_name`, `recipient_phone`, `line1`, `line2`, `city_id`, `city_name`, `latitude`, `longitude`, `is_default` |
| Profile address | POST | `pharmacyProfileAddress` → `…/pharmacy/profile/address` | `{ "lat": "0", "long": "0", "category": {}, "address", "region": "<city name>", "line1", "city_id" }` — called on checkout confirm **only when no saved address matches** checkout `line1` (+ city); if address field empty, uses selected city; returned `address_id`/`id` becomes checkout `user_location_id` |
| Bookings list | GET | `pharmacyBookings` / `mobileBookings(type: pharmacy)` → `…/mobile/bookings?type=pharmacy&page=&limit=` | Response `data.data[]`: `orderId`, `productName`, `imageUrl`, `quantity`, `unitPrice`, `total`, `currency`, `status` (`PENDING` / `PAYMENT_FAILED` / `ACCEPTED` / `CONFIRMATION_PENDING` / `ORDER_VERIFICATION` / …), `createdAt`; paging via `page` / `limit` / `total` |
| Booking detail | GET | `pharmacyBookingDetail(orderId)` → `…/mobile/bookings/{orderId}` | `data`: `orderId`, `orderNo`, `status`, `statusTimeline[]` (`label`, `completed`), `items[]` (`productName`, `quantity`, `unitPrice`, `lineTotal`, `imageUrl`), `subtotal`, `deliveryCharge`, `discount`, `discountPercent`, `total`, `paymentMethod`, `deliveryAddress`, `city` |

Products response: `{ success, message, code, data: { data: [...], page, limit, total, totalPages, hasNextPage }, timestamp }`. Each product: `product_id`, `display_name`, `image_url`, `price`, `manufacturer` (string), `category`, `prescription_required`, `generic_name`, `package_type`, `indications`, `contra_indications`, `images[]`. Parsed by `PharmacyMedicineModel` → `PharmacyMedicineEntity` (`manufacturer`, `genericName`, etc.). Legacy shapes (`id`, `media.file`, nested `data.data.data`, `current_page`/`last_page`) still supported.

Cart products: each `products[]` row may nest `product { …Partner product fields… }` or be flat. Line fields: `id` (cart line), `product_id`, `quantity`, `unitPrice`/`unit_price`/`price` (unit), `line_total`/`lineTotal`/`total`/`subtotal`. UI shows `displayUnitPrice` from `unitPrice`; cart totals use `lineTotal` when present.

## State

- `PharmacyCubit` — server-side search on search-icon tap (`submitSearch` → `display_name`); clearing the field reloads all products. Search field stays visible during loading/error/empty. Pagination (`loadMoreMedicines`), `loadProductDetail(productId)`, `loadCart()` for active cart + `cartBookingId` + `cartAddresses` from `family_members[].addresses` (**logged-in only**; guests skip cart APIs). Cart icon / add-to-cart require login (`AuthGuard` → login). Add-to-cart: if product already in cart, quantity-update only; else add API. Heart loader on add + cart +/-. Checkout open: load addresses list (prefill list → profile → city). Checkout confirm: if JazzCash, opens shared JazzCash Select Account sheet then checkout includes `jazz_cash_number` (`92…` digits). If address empty use selected city; if checkout address matches a saved `line1` (+ city), reuse that `address_id` and **skip** create-address API; otherwise POST profile address then checkout with `user_location_id` + `payment_method` + `prescriptions` + optional `delivery_instructions` (+ `jazz_cash_number` for JazzCash). Guest DTO fields are unused (login required). If checkout `data.paymentUrl` is present, opens `AppRoutes.cardPayment` before the order-placed dialog. On success shows order-placed dialog, clears cart, navigates to booking details with `orderNo`. City via shared `showSelectCityDialog` / `CitiesRepository`; totals from active-cart `payment_breakdown`.

## Mocks

`PharmacyMockApi` when `MockConfig.enableMocks` is true; `getPharmacyProductsSuccessResponse` mirrors aggregator shape and filters by `display_name`.

## Routes / entry

- `AppRoutes.pharmacyMain` — pharmacy dashboard (medicines home).
- `AppRoutes.pharmacyCart`, `AppRoutes.pharmacyCheckout`, `AppRoutes.pharmacyBookingDetails`.

## Order placed flow

After checkout confirm + order-placed dialog: `pharmacyGoToOrderDetailsAfterPlace` → `home` → `pharmacyMain` → `pharmacyBookingDetails`. Back: details → pharmacy main → home shell. `pharmacyPopOrGoHome` on hub/details headers if the stack is empty.
