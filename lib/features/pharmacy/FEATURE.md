# Pharmacy feature

## Purpose

Browse medicines, cart, checkout, and view pharmacy order details.

## Data & APIs

| Action | Method | `AppUrls` | Body |
|--------|--------|-----------|------|
| List products | POST | `pharmacyProducts` → `acs-aggregator/api/v1/mobile/partner/pharmacy/products` | `{ "page": "1", "display_name": "" }` — pass search text in `display_name` when searching; empty for browse |
| Product detail | POST | `pharmacyProductDetail` → `acs-aggregator/api/v1/mobile/partner/pharmacy/product/details` | `{ "product_id": <id> }` (int) — product in `data` with Partner fields (`product_id`, `display_name`, `image_url`, `price`, `manufacturer`, `category`, `prescription_required`, `generic_name`, `package_type`, `indications`, `contra_indications`, `images[]`); optional `related_items[]` for “More like” |
| Cart (active) | POST | `pharmacyCart` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/active` | `{}` — cart in `data` or `data.data`: `products[]`, `booking_id` / `booking.id`, `payment_breakdown`, `family_members[].addresses` |
| Add to cart | POST | `pharmacyAddToCart` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/add` | `{ "product_id": <id>, "quantity": <n> }` — both **int**; on success, update local cart/`cartBookingId` from response (no active-cart refetch) |
| Update cart qty | POST | `pharmacyUpdateCartQuantity` → `acs-aggregator/api/v1/mobile/partner/pharmacy/cart/quantity/update` | `{ "product_id": <id>, "quantity": <n> }` — both **int**; on success, update local cart from response (no active-cart refetch) |
| Order checkout | POST | `pharmacyOrderCheckout` → `…/pharmacy/order/checkout` | `multipart/form-data`: `guest_phone`, `guest_name`, `payment_method` (`JAZZCASH` / `CARD` / `COD`), `guest_address_city_id` — phone from profile (`92…` MSISDN), name from profile, city id from `CitiesRepository.cityIdForName` |
| Profile address | POST | `pharmacyProfileAddress` → `…/pharmacy/profile/address` | `{ "lat": "", "long": "", "category": {}, "address", "region" }` — available via `AddPharmacyProfileAddressUseCase` (not called on checkout) |

Products response: `{ success, message, code, data: { data: [...], page, limit, total, totalPages, hasNextPage }, timestamp }`. Each product: `product_id`, `display_name`, `image_url`, `price`, `manufacturer` (string), `category`, `prescription_required`, `generic_name`, `package_type`, `indications`, `contra_indications`, `images[]`. Parsed by `PharmacyMedicineModel` → `PharmacyMedicineEntity` (`manufacturer`, `genericName`, etc.). Legacy shapes (`id`, `media.file`, nested `data.data.data`, `current_page`/`last_page`) still supported.

Cart products: each `products[]` row may nest `product { …Partner product fields… }` or be flat. Line fields: `id` (cart line), `product_id`, `quantity`, `unitPrice`/`unit_price`/`price` (unit), `line_total`/`lineTotal`/`total`/`subtotal`. UI shows `displayUnitPrice` from `unitPrice`; cart totals use `lineTotal` when present.

## State

- `PharmacyCubit` — server-side search on search-icon tap (`submitSearch` → `display_name`); clearing the field reloads all products. Search field stays visible during loading/error/empty. Pagination (`loadMoreMedicines`), `loadProductDetail(productId)`, `loadCart()` for active cart + `cartBookingId` + `cartAddresses` from `family_members[].addresses` (**logged-in only**; guests skip cart APIs). Cart icon / add-to-cart require login (`AuthGuard` → login). Add-to-cart: if product already in cart, quantity-update only; else add API. Heart loader on add + cart +/-. Checkout confirm: validates address + city; POST checkout multipart with profile phone/name and selected city id. On success shows order-placed dialog, clears cart, navigates to booking details with `orderNo`. City via shared `showSelectCityDialog` / `CitiesRepository`; delivery address prefilled from `UserLocalModel.address`; totals from active-cart `payment_breakdown`.

## Mocks

`PharmacyMockApi` when `MockConfig.enableMocks` is true; `getPharmacyProductsSuccessResponse` mirrors aggregator shape and filters by `display_name`.

## Routes / entry

- `AppRoutes.pharmacyMain` — pharmacy dashboard (medicines home).
- `AppRoutes.pharmacyCart`, `AppRoutes.pharmacyCheckout`, `AppRoutes.pharmacyBookingDetails`.

## Order placed flow

After checkout confirm + order-placed dialog: `pharmacyGoToOrderDetailsAfterPlace` → `home` → `pharmacyMain` → `pharmacyBookingDetails`. Back: details → pharmacy main → home shell. `pharmacyPopOrGoHome` on hub/details headers if the stack is empty.
