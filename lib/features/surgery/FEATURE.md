# Surgery feature

## Purpose
Browse surgical procedures by city, select a doctor/hospital offer, complete patient details, and submit a surgery booking request. Related booking history lives under the Bookings tab.

## Routes / entry
- `AppRoutes.surgery` → `/surgery` (`SurgeryScreen` with `BlocProvider<SurgeryCubit>`)
- Booking flow: `SurgeryBookingScreen` → `SurgeryPatientDetailsScreen` (Navigator push, shares `SurgeryCubit`)
- Bookings: `SurgeryBookingsScreen` (Bookings dashboard tab) → `AppRoutes.surgeryBookingDetails`

## Data & APIs
| Screen | Method | `AppUrls` key | Mock class |
|--------|--------|---------------|------------|
| Procedures list | GET | `surgeryProcedures` | `SurgeryMockApi` |
| Doctor offers | GET | `surgeryDoctors(procedure, city)` | `SurgeryDoctorsMockApi` |
| Patient form | GET | `surgeryPatientForm(doctorId)` | `SurgeryPatientFormMockApi` |
| Submit booking | POST | `surgeryBooking` | `SurgeryCheckoutMockApi` |

Bookings list/details: `SurgeryBookingsMockApi` in `lib/features/bookings/data/mock/` (used by `SurgeryBookingsScreen`).

All surgery mocks use `MockConfig.enableMocks` (`useMockResponses` static on each mock class). On in debug or with `--dart-define=MOCKTRUE=true`.

## State
- `SurgeryCubit` / `SurgeryState`: content load, city/search, doctors load, patient form load, `submitSurgeryBooking`
- Status fields: `loadingStateStatus`, `doctorsLoadingStateStatus`, `patientFormLoadingStateStatus`

## DI
`initSurgeryInjector()` registers mocks, `SurgeryRemoteDataSourceImpl`, repository, use cases, factory `SurgeryCubit`.

## Mocks
- `SurgeryMockApi` — cities, procedures (with descriptions)
- `SurgeryDoctorsMockApi` — doctors filtered by procedure + city
- `SurgeryPatientFormMockApi` — surgery options + patient prefill per doctor
- `SurgeryCheckoutMockApi` — booking submit success + `bookingId`
