# Routes and screen ownership

Owner of `app_router.dart` and `routes.dart`: **Dev1**. Everyone else changes
them only with a small PR (one route per PR) or by asking in the group.

How to wire your real screen (replace the placeholder):

1. Create the view in your feature folder.
2. In `app_router.dart`, change the `_placeholder('...')` of your route to
   `const YourView()` (wrap it in a `BlocProvider` if it needs a cubit).
3. If you need a **new** route, add its name to `routes.dart` as a constant
   (nested routes: no leading slash) and tell Dev1.

Navigation rules:

- Inside a tab: `context.push(...)`. Between tabs: `context.go(...)`.
- Never call `FirebaseAuth` directly. Use `getIt<AuthSession>()`
  (`uid`, `email`, `profile`...).
- Collection and Storage paths come from `core/constants/firestore_paths.dart`.

## Guards (done by `redirect` in `app_router.dart`)

| Situation | Where the user can be |
|---|---|
| Onboarding not seen | `/onboarding` only |
| Signed out | login, sign up, forgot password, reset sent, `/terms` |
| Signed in, email not verified | `/verifyEmail` only |
| Signed in, verified, profile not loaded | `/splash` (a moment) |
| Signed in, verified | everything else |

To skip the guards while developing: `flutter run --dart-define=BYPASS_AUTH=true`.
To use the local emulators: `flutter run --dart-define=USE_EMULATOR=true`.

## Screens

Status: **real** = screen is wired, **placeholder** = route exists, screen not
connected yet.

| Area | Screen | Route | Owner | Status |
|---|---|---|---|---|
| Auth | Onboarding (3 pages) | `/onboarding` | Dev1 | real |
| Auth | Log in | `/login` | Dev1 | real |
| Auth | Sign up | `/signUp` | Dev1 | real |
| Auth | Verify email | `/verifyEmail` | Dev1 | real |
| Auth | Forgot password / Reset sent | `/forgotPassword`, `/resetSent` | Dev1 | real |
| Auth | Complete profile | `/completeProfile` | Dev1 | real |
| Profile | Profile | `/profile` | Dev1 | real |
| Profile | Personal info | `/profile/personalInfo` | Dev1 | real |
| Profile | Medical info | `/profile/medicalInfo` | Dev1 | real |
| Profile | Notification settings | `/profile/notification` | Dev1 | real |
| Profile | Account & privacy (+ delete account) | `/profile/accountPrivacy` | Dev1 | real |
| Home | Home | `/home` | Dev2 | placeholder |
| Home | Notifications | `/home/notifications` | Dev2 | placeholder |
| Home | Emergency numbers (sheet) | `/home/emergency` | Dev2 | placeholder |
| Doctors | Find doctors | `/doctors` | Dev3 | placeholder |
| Doctors | Doctor profile | `/doctors/doctor-details` | Dev3 | placeholder |
| Doctors | Book appointment | `/doctors/select-time-slot` | Dev3 | placeholder (name to confirm) |
| Doctors | Appointment confirmed | `/doctors/booking-success` | Dev3 | placeholder |
| Doctors | My appointments | `/doctors/my-appointments` | Dev3 | placeholder |
| Blood | Request blood (2 steps) + posted | `/bloodDonation/request-blood` | Dev4 | real |
| Blood | Request details (requester / donor) | `/bloodDonation/request-details` | Dev4 | real |
| Blood | Donor registration + success | `/bloodDonation/donor-registration` | Dev4 | real |
| Blood | Donation history | `/bloodDonation/donation-history` | Dev4 | real |
| Blood | Blood donation (map) | `/bloodDonation` | Dev4 | temporary launcher |
| Records | Medical records | `/medicalRecords` | Dev5 | placeholder |
| Records | Scanner | `/medicalRecords/scan-document` | Dev5 | placeholder |
| Records | Review document | `/medicalRecords/review-document` | Dev5 | placeholder |
| Records | Record detail | `/medicalRecords/record-details` | Dev5 | placeholder |

Sheets and dialogs (filter, cancel appointment, add a record, donate
confirmation, states) are not routes: open them with `showModalBottomSheet` /
`showDialog`.

### Leftover placeholders from the first design

These are not in the final 41 screens and are safe to delete when their owner
confirms: `/home/search-global`, `/home/banner-details`, `/home/articles-list`,
`/doctors/specialties`, `/doctors/payment-method`, `/doctors/booking-summary`,
`/medicalRecords/upload-prescription`, `/medicalRecords/prescriptions-list`.
