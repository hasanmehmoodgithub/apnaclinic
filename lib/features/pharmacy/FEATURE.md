# Pharmacy feature

## Purpose

Browse medicines, cart, checkout, and view pharmacy order details.

## Data & APIs

| Action | Method | `AppUrls` | Body |
|--------|--------|-----------|------|
| List products | POST | `pharmacyProducts` → `acs-aggregator/api/v1/mobile/partner/pharmacy/products` | `{ "page": "1", "display_name": "" }` — pass search text in `display_name` when searching; empty for browse |
| Product detail | POST | `pharmacyProductDetail` → `acs-aggregator/api/v1/mobile/partner/pharmacy/product/details` | `{ "product_id": <id> }` (int) — returns product + `related_items[]` for “More like” list |
| Cart (active) | POST | `pharmacyCart` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/active` | `{}` — cart in `data` or `data.data`: `products[]`, `booking_id` / `booking.id`, `payment_breakdown`, `family_members[].addresses` |
| Add to cart | POST | `pharmacyAddToCart` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/add` | `{ "product_id": <id>, "quantity": <n> }` — both **int**; on success, update local cart/`cartBookingId` from response (no active-cart refetch) |
| Update cart qty | POST | `pharmacyUpdateCartQuantity` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/quantity/update` | `{ "product_id": <id>, "quantity": <n> }` — both **int**; on success, update local cart from response (no active-cart refetch) |
| Order checkout | POST | `pharmacyOrderCheckout` → `…/pharmacy/order/checkout` | `{ "booking_id", "patient_id", "user_location_id", "payment_method" }` — all strings; `patient_id` from profile/`AppPref`; `user_location_id` prefers matched/added profile address id, else cities `cityIdForName`; payment `JAZZCASH` / `CARD` / `COD` |
| Profile address | POST | `pharmacyProfileAddress` → `…/pharmacy/profile/address` | `{ "lat": "", "long": "", "category": {}, "address", "region" }` — called **before checkout** only when cart `family_members[].addresses` is null/empty or no address matches the checkout address field |

Products response: `{ success, message, code, data: { data: [...], page, limit, total, totalPages, hasNextPage }, timestamp }`. Each product: `product_id`, `display_name`, `image_url`, `price`, `manufacturer` (string), `category`, `prescription_required`, `generic_name`, `package_type`, `indications`, `contra_indications`, `images[]`. Parsed by `PharmacyMedicineModel` → `PharmacyMedicineEntity` (`manufacturer`, `genericName`, etc.). Legacy shapes (`id`, `media.file`, nested `data.data.data`, `current_page`/`last_page`) still supported.

Cart products: each `products[]` row may nest `product { …Partner product fields… }` or be flat. Line fields: `id` (cart line), `product_id`, `quantity`, `unitPrice`/`unit_price`/`price` (unit), `line_total`/`lineTotal`/`total`/`subtotal`. UI shows `displayUnitPrice` from `unitPrice`; cart totals use `lineTotal` when present.

## State

- `PharmacyCubit` — server-side search on search-icon tap (`submitSearch` → `display_name`); clearing the field reloads all products. Search field stays visible during loading/error/empty. Pagination (`loadMoreMedicines`), `loadProductDetail(productId)`, `loadCart()` for active cart + `cartBookingId` + `cartAddresses` from `family_members[].addresses` (**logged-in only**; guests skip cart APIs). Cart icon / add-to-cart require login (`AuthGuard` → login). Add-to-cart: if product already in cart, quantity-update only; else add API. Heart loader on add + cart +/-. Checkout confirm: if cart has no matching address for the checkout address field, POST profile address (`address` + `region`/city; empty `lat`/`long`, `{}` category) then checkout; if same address already exists, skip address API. On success shows order-placed dialog, clears cart, navigates to booking details with `orderNo`. Cities via `CitiesRepository`; delivery address prefilled from `UserLocalModel.address`; totals from active-cart `payment_breakdown`.

## Mocks

`PharmacyMockApi` when `MockConfig.enableMocks` is true; `getPharmacyProductsSuccessResponse` mirrors aggregator shape and filters by `display_name`.

## Routes / entry

- `AppRoutes.pharmacyMain` — pharmacy dashboard (medicines home).
- `AppRoutes.pharmacyCart`, `AppRoutes.pharmacyCheckout`, `AppRoutes.pharmacyBookingDetails`.

## Order placed flow

After checkout confirm + order-placed dialog: `pharmacyGoToOrderDetailsAfterPlace` → `home` → `pharmacyMain` → `pharmacyBookingDetails`. Back: details → pharmacy main → home shell. `pharmacyPopOrGoHome` on hub/details headers if the stack is empty.
