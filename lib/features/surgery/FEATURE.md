# Surgery feature

## Purpose
Browse surgical procedures by city, select a doctor/hospital offer, complete patient details, and submit a surgery booking request. Related booking history lives under the Bookings tab.

## Routes / entry
- `AppRoutes.surgery` → `/surgery` (`SurgeryScreen` with `BlocProvider<SurgeryCubit>`)
- Booking flow: `SurgeryBookingScreen` → `SurgeryPatientDetailsScreen` (Navigator push, shares `SurgeryCubit`). Book Now requires login (`AppPref.getLoginStatus()`); guests go to `AppRoutes.authLogin`.
- Bookings: `SurgeryBookingsScreen` (Bookings dashboard tab) → `AppRoutes.surgeryBookingDetails`

## Data & APIs
| Screen | Method | `AppUrls` key | Mock class |
|--------|--------|---------------|------------|
| Procedures list | GET | `surgeryProcedures(cityId?)` → `/api/v1/mobile/surgery/list?cityId=` (optional city filter) | `SurgeryMockApi` |
| Doctor offers | GET | `surgeryProviders(surgeryId, cityId)` → `/api/v1/mobile/surgery/providers?surgeryId=&cityId=` — response `data.items[]` (`doctorId`, `doctorName`, `profileImageUrl`, `specialty`, `yearsOfExperience`, `education`, `hospitalName`, `price`, `discountedPrice`, `partnerLogoUrl`, …) | `SurgeryDoctorsMockApi` |
| Patient form | GET | `surgeryPatientForm(doctorId)` | `SurgeryPatientFormMockApi` |
| Submit booking | POST | `surgeryBooking` | `SurgeryCheckoutMockApi` |

Aggregator list maps `data[]` items: `id`, `name`, `slug`, `image`, `description`, optional `displayOrder` / `isActive`. City picker uses **`CitiesRepository`** (prefetched at app open from `AppUrls.cities` → `/api/v1/mobile/cities`).

Bookings list/details: `SurgeryBookingsMockApi` in `lib/features/bookings/data/mock/` (used by `SurgeryBookingsScreen`).

Surgery mocks use `MockConfig.enableSurgeryMocks` (default false).

## State
- `SurgeryCubit` / `SurgeryState`: content load (re-fetches procedures when city changes), city/search, doctors load, patient form load, `submitSurgeryBooking` (includes `gender`)
- Status fields: `loadingStateStatus`, `doctorsLoadingStateStatus`, `patientFormLoadingStateStatus`

## DI
`initSurgeryInjector()` registers mocks, `SurgeryRemoteDataSourceImpl`, repository, use cases, factory `SurgeryCubit`.

## Mocks
- `SurgeryMockApi` — aggregator-shaped surgery list
- `SurgeryDoctorsMockApi` — doctors filtered by procedure + city
- `SurgeryPatientFormMockApi` — surgery options + patient prefill per doctor
- `SurgeryCheckoutMockApi` — booking submit success + `bookingId`
