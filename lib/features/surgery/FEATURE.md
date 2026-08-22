# Surgery feature

## Purpose
Browse surgical procedures by city, select a doctor/hospital offer, complete patient details, and submit a surgery booking request. Related booking history lives under the Bookings tab.

## Routes / entry
- `AppRoutes.surgery` → `/surgery` (`SurgeryScreen` with `BlocProvider<SurgeryCubit>`)
- `AppRoutes.surgeryBooking` → `/surgery-booking` (`SurgeryBookingEntryScreen` → `SurgeryBookingScreen`; procedure doctor list)
- `AppRoutes.surgeryPatientDetails` → `/surgery-patient-details` (patient form; also opened from global search surgery offers)
- Booking flow: `SurgeryBookingScreen` → `SurgeryPatientDetailsScreen` (`BlocProvider<SurgeryPatientDetailsCubit>`). Book Now passes `surgeryId`, `cityId`, and `doctorId`; guests go to `AppRoutes.authLogin`.
- Bookings: `SurgeryBookingsScreen` (Bookings dashboard tab) → `AppRoutes.surgeryBookingDetails`

## Data & APIs
| Screen | Method | `AppUrls` key | Mock class |
|--------|--------|---------------|------------|
| Procedures list | GET | `surgeryProcedures(cityId?)` → `/api/v1/mobile/surgery/list?cityId=` (optional city filter) | `SurgeryMockApi` |
| Doctor offers | GET | `surgeryProviders(surgeryId, cityId)` → `/api/v1/mobile/surgery/providers?surgeryId=&cityId=` — response `data.items[]` (`doctorId`, `doctorName`, `profileImageUrl`, `specialty`, `yearsOfExperience`, `education`, `hospitalName`, `price`, `discountedPrice`, `partnerLogoUrl`, …) | `SurgeryDoctorsMockApi` |
| Provider packages | GET | `surgeryProviderDetails(surgeryId, cityId, doctorId)` → `/api/v1/mobile/surgery/provider-details?surgeryId=&cityId=&doctorId=` — response `data.doctor`, `data.packages[]` (`packageId`, `packageName`, `price`, `discountedPrice`, `hospitalName`, `tatMessage`, …). Auto-loaded on patient details open (default package) and when user opens the surgery type picker. | `SurgeryProviderDetailsMockApi` |
| Patient form | GET | `surgeryPatientForm(doctorId)` | `SurgeryPatientFormMockApi` |
| Submit booking (lead) | POST | `surgeryBooking` → `/api/v1/mobile/surgery/lead` — **Confirm Booking** on patient details; body `{ doctorId, surgeryId (procedure id), packageId, cityId, patient: { name, age, gender, phone, emergencyPhone } }` | `SurgeryCheckoutMockApi` |
| Book / pay surgery lead | POST | `surgeryBookSurgery` → `/api/v1/mobile/surgery/book-surgery` — Bookings details **Proceed Checkout** after payment method (`PaymentMethodSheet` with `module=surgery`) (+ JazzCash account); body `{ leadId, paymentMethod, msisdn }`. If `status` is `PENDING_PAYMENT` and no `paymentUrl`, show shared `PaymentPendingDialogWidget` (View My Bookings → surgery tab). If `data.paymentUrl` present → `AppRoutes.cardPayment` before confirmed dialog | `SurgeryCheckoutMockApi.bookSurgery` |
| Surgery leads (bookings list) | GET | `surgeryLeads(page, limit)` → `/api/v1/mobile/surgery/lead?page=&limit=` — `data.items[]` (`leadId`, `surgeryId`, `surgeryType`, `subSurgeryType`, `provider` `{id,name,logoUrl?}`, `doctor` `{id,name,specialty,education,hospitalName?}`, `status` e.g. `PENDING`/`PAID`, `paymentAllowed`, `patient`, `pricing` `{ fee, discount, total }`, `confirmedDate`, `scheduledDate` (date-only `YYYY-MM-DD`), `scheduledStartTime`, `scheduledEndTime` (PKT slot strings), …) via `GetSurgeryLeadsUseCase` | `SurgeryLeadsMockApi` |
| Surgery lead detail | GET | `surgeryLeadDetail(leadId)` → `/api/v1/mobile/surgery/lead/{leadId}` — single lead in `data` (same fields as list item, including split schedule date/times); used by Bookings **View Details** via `GetSurgeryLeadUseCase` | `SurgeryLeadsMockApi.getSurgeryLeadSuccessResponse` |

Aggregator list maps `data[]` items: `id`, `name`, `slug`, `image`, `description`, optional `displayOrder` / `isActive`. City picker uses shared **`showSelectCityDialog`** / **`CitiesRepository`** (`AppUrls.cities`).

Bookings tab (`SurgeryBookingsScreen`) maps leads with `SurgeryBookingListMapper` → detail args.

Surgery mocks use `MockConfig.enableSurgeryMocks` (default false).

## State
- `SurgeryCubit` / `SurgeryState`: content load (re-fetches procedures when city changes), city/search, doctors load, provider details load (surgery type packages), patient form load, `submitSurgeryBooking` (lead API: `doctorId` + procedure `surgeryId` + `packageId` + `cityId` + patient)
- Last selected city persists in `AppPrefKeys.surgerySelectedCity` (restored on open; saved in `changeCity`)
- Status fields: `loadingStateStatus`, `doctorsLoadingStateStatus`, `providerDetailsLoadingStateStatus`, `patientFormLoadingStateStatus`
- Booking doctors filter dialog (`SurgeryBookingFilterSheetWidget`): main step shows Hospital / Speciality rows + **Apply Filter**; tapping a hospital or specialty option immediately returns to the main step (no nested Proceed)
- Patient details (`SurgeryPatientDetailsScreen`): no `setState` — UI/form/submit driven by `SurgeryPatientDetailsCubit` (`BlocBuilder` / `BlocListener`); text controllers only for field input. Validation: name required; age > 0; contact & emergency = 10 or 11 digits (max input 11; user-facing copy says “valid number”). Booking API success → submitted dialog (non-cancelable: barrier + back blocked; **View My Bookings** → Bookings → Surgery tab); failure → failed dialog (API message or fallback)

## DI
`initSurgeryInjector()` registers mocks, `SurgeryRemoteDataSourceImpl`, repository, use cases (`GetSurgeryLeadsUseCase`, `GetSurgeryLeadUseCase` included), factory `SurgeryCubit`, factory `SurgeryPatientDetailsCubit`.

## Mocks
- `SurgeryMockApi` — aggregator-shaped surgery list
- `SurgeryDoctorsMockApi` — doctors filtered by procedure + city
- `SurgeryProviderDetailsMockApi` — surgery type packages per doctor
- `SurgeryPatientFormMockApi` — surgery options + patient prefill per doctor
- `SurgeryCheckoutMockApi` — lead submit success + `bookingId`
- `SurgeryLeadsMockApi` — paginated leads list for bookings tab
