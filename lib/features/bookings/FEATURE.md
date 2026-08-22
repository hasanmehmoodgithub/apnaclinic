# Bookings feature

## Purpose

Tabbed bookings hub (Instant Doctor, Pharmacy, Doctor Consultation, Lab Tests, Surgery) with list cards and detail screens.

## Routes / entry

- `BookingsDashboardScreen` — bottom nav tab; menu tile switches to this tab; inner tabs in order: Instant Doctor, Pharmacy, Doctor Consultation, Lab Tests, Surgery (`BookingsTabs`). `AppRoutes` booking detail routes per type. Instant Doctor has no bookings list API yet (`InstantDoctorBookingsScreen` empty state opens the Instant Doctor bottom tab).
- `AppRoutes.doctorConsultationBookingDetails` — consultation booking details; extra: `DoctorConsultationBookingDetailsArgs` (`bookingId`, optional preloaded `booking` from list).

## Data & APIs

- Doctor consultation list: **GET** `AppUrls.doctorConsultationBookings(page, limit)` via `GetConsultationBookingsUseCase` (consultation module). Maps API items to `DoctorConsultationBookingDetailsModel` in `DoctorConsultationBookingMapper`.
  - Item fields: `appointmentId`, **`orderId`** (used as booking/navigation id for detail GET), `doctorInfo` (`doctorid`, `displayName`, `specialtyName`, `profileImageUrl`, fees/`discountPercent`/`isFree`, `ratings`, `pmdcVerified`, `partner`), `patientRelation`, `slotDate`/`slotStartTime`/`slotEndTime`, `success` (`PAID` → Confirmed, `PENDING_PAYMENT` → Pending, `FAILED` → **Failed** on list and details), `partnerRefNo` (feedback `refNo`), `meetingLink`, `issue`, `attachments`, `doctorPerscriptions` (API spelling; mapped as `doctorPrescriptions`), `patientReview` (`rating`/`review`/`date`).
- Doctor consultation details: **GET** `AppUrls.doctorConsultationBookingDetail(orderId)` via `GetConsultationBookingUseCase` — single consultation in `data` (same fields as list item). List payload is preload only; details always refetch. Failed loads render shared `EmptyBookingWidget` with the API message and retry CTA.
- Join Consultation (on booking details, after **View Details**) is enabled only while current time is within slot `[start, end]` (confirmed + `meetingLink`). Outside that window the CTA stays visually disabled (faded label); tapping it shows a speech-bubble tooltip (`DoctorConsultationJoinDisabledTooltipWidget`) with `bookingsJoinConsultationDisabledTooltip`.
- Patient’s Review / Feedback submit form is available only after slot end (submitted review always shown if present).
- Submit feedback (when no existing review, non-cancelled): **POST** `AppUrls.doctorConsultationFeedback` via `SubmitConsultationFeedbackUseCase` — body `{ refNo, rating, review }` (`refNo` = `partnerRefNo` / booking id).
- Surgery leads list: **GET** `AppUrls.surgeryLeads(page, limit)` via `GetSurgeryLeadsUseCase` (surgery module). Mapped by `SurgeryBookingListMapper`:
  - Status: API `status` (`PENDING` → Pending, `PAID` → Paid); **Proceed Checkout** shown only when API `paymentAllowed` is `true`.
  - Pricing: `fee`, `discount`, `total` (legacy `discountFee`/`quotedPrice`/`finalPrice` still parsed).
  - Appointment: `scheduledDate` (date-only), `scheduledStartTime` / `scheduledEndTime` (PKT, shown as e.g. `8:00 PM - 11:00 PM`). Legacy datetime `scheduledDate` with midnight is ignored for time. If no schedule → “Awaiting confirmation.” + Applied On (no fake created date as schedule). Patient includes `gender`; phones as local `03…`.
  - Card: `surgeryType` + `subSurgeryType`; doctor + specialty/education; clinic `hospitalName` (not partner name); partner logo from `provider` id/name/logo. List and details reuse the same `SurgeryDetailsItem` via `SurgeryBookingCardWidget` (details omits View Details).
  - Navigation: `SurgeryBookingDetailsArgs(leadId, item, initialStatus)` with `ValueKey(leadId)` so the tapped lead is opened. Details screen then **GET** `AppUrls.surgeryLeadDetail(leadId)` via `GetSurgeryLeadUseCase` and remaps with `SurgeryBookingListMapper` (list payload is only a preload).
- Surgery pay / book: **POST** `AppUrls.surgeryBookSurgery` via `BookSurgeryUseCase` from booking details **Proceed Checkout** (visible only when `paymentAllowed`). Opens `PaymentMethodSheet(module: surgery)` → `GET AppUrls.paymentProviders(module: surgery)` with API `iconUrl` and local JazzCash/card fallbacks → shared JazzCash Select Account sheet (`ProfileSessionSync`/prefs; accounts GET only after Add Account) → body `{ leadId, paymentMethod, msisdn }`. If response includes `data.paymentUrl`, opens shared card payment WebView before the confirmed dialog. Lab checkout uses the same sheet with `includeLocalCashOption: true` so **Pay via Cash** (`COD`) is shown in addition to API providers.
- Surgery details title: `bookingsSurgeryDetailsTitle` (“Details”).
- Lab test orders list: **GET** `AppUrls.labOrders(page, limit)` via `GetLabOrdersUseCase` (lab_test module). Response shape and models documented in `lib/features/lab_test/FEATURE.md`. Mapped by `LabTestBookingListMapper.fromOrder` into `LabTestBookingItemModel`. Empty list **Book Lab Test** opens `AppRoutes.labTest` (catalog).
  - Status: `Confirmed` → teal **Confirmed**; `Payment Pending` / `Pending` / `PLACED` → amber **Pending**; cancelled/rejected/failed → red pill.
  - List card (`LabTestBookingCardWidget`): microscope icon, **Order No.** + id, static subtitle “Lab Test Report”, date (`placedAt` / `createdAt`), footer **Status** | **Total Fee** | **View Details**. Right-side decoration uses `Assets.labTestCardVector`; no partner/lab logos on the list card.
  - Fee: `pricing.total` formatted `Rs. n,nnn/-`.
  - **View Details** opens `LabTestViewDetailsScreen` with `LabTestViewDetailsArgs(orderId)` then loads **GET** `AppUrls.labOrderById` (`/acs-aggregator/api/v1/mobile/lab-orders/{id}`) via `GetLabOrderDetailUseCase`. Response is mapped with `LabTestBookingListMapper.toViewDetailsContent` (patient, fees, logos, `partnerRef`/discount code, report note). **Sample Type** pill uses API `orderType`: `HOME_SAMPLING` → Home Sample, `WALK_IN` → Walk In (fallback N/A). Status pill uses the same Pending (amber) / Confirmed (teal) / failed (red) colors as the list. E-invoice is not shown.
- Pharmacy bookings list: **GET** `AppUrls.pharmacyBookings(page, limit)` (`…/mobile/bookings?type=pharmacy&…`) via `GetPharmacyBookingsUseCase` (pharmacy module). Items: `orderNo`, `orderId`, `productName`, `imageUrl`, `quantity`, `unitPrice`, `total`, `status`, `createdAt`. List card shows product image, qty×unit, total, status label; whole card (and **View Details**) → `AppRoutes.pharmacyBookingDetails` with **`orderId` only** for the detail GET (`AppUrls.pharmacyBookingDetail(orderId)`). `orderNo` is display-only (header fallback). After pharmacy checkout order-placed dialog, shell opens Bookings → Pharmacy tab (`BookingsTabs.pharmacy`).

## State

- `DoctorConsultationBookingsCubit` — paginated consultation bookings list (page 1, limit 20; infinite scroll load-more). Initial load uses `BookingsListShimmerWidget`. Empty list shows `EmptyBookingWidget` with “No Booking Available”.
- `DoctorConsultationBookingDetailsCubit` — always **GET** detail by `orderId` (`GetConsultationBookingUseCase`); optional list `booking` is preload while shimmering; maps via `DoctorConsultationBookingMapper`; submits feedback and updates local `patientReview` on success.

## UI

- `DoctorConsultationBookingCardWidget` — consultation list card; whole card opens booking details on tap; **View Details** button uses the same navigation.
- `DoctorConsultationBookingDetailsContentWidget` — thin composer for details body; sections: header (doctor + date card), patient/issue fields, review or feedback form, documents (name + Download under icon), billing (fee breakdown only; **E-Invoice** is hidden until the API provides an invoice URL), join CTA. Rating badge uses shared `AppRoundedRatingWidget` (whole numbers without decimals).
- `DoctorConsultationBookingFeedbackFormWidget` — rating + review + submit when `patientReview` is missing (hidden for cancelled); layout matches submitted review card (title, “Your Feedback” + date, stars + score chip, `#F7F7F7` text area).

## Analytics

Firebase via `BookingsAnalytics` / `AnalyticsService`. `my_bookings_tab` fires when the bottom Bookings tab is shown. `booking_viewed` fires after details load for consultancy / pharmacy / lab / surgery (`type`). Instant Doctor has no booking-details screen yet. `prescription_available` fires when consultation details include doctor prescriptions, and when a push/inbox `type` contains `PRESCRIPTION` (`service` `consultancy` / `instant_doctor`). `prescription_downloaded` fires on prescription file tap. `pharmacy_status_changed` fires from push/inbox when `serviceType` is `PHARMACY` and `type` contains `STATUS` / `DELIVER` / `DISPATCH` (`changed_by` only if the payload includes it). Meta/TikTok keys are not sent.

| Event | When | Params |
|---|---|---|
| `my_bookings_tab` | Bookings bottom tab is shown | — |
| `booking_viewed` | Booking details load | `type` (`consultancy` / `pharmacy` / `lab` / `surgery`) |
| `prescription_available` | Consultation details have prescriptions, or prescription push | `booking_id`, `service` |
| `prescription_downloaded` | User taps a consultation prescription | `booking_id`, `service`, `user_name`, `msisdn` |
| `pharmacy_status_changed` | Pharmacy status push / inbox | `booking_id`, `status`, `changed_by` |

## Mocks

- Consultation detail/list mocks live in consultation module (`ConsultationBookingsListMockApi`) when `MockConfig.enableConsultationMocks` is true.
