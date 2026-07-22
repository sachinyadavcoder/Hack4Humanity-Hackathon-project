# MotherCare Prototype Walkthrough

I have completed the frontend prototype for MotherCare! All 15 requested screens have been built and linked together.

## Changes Made
- Set up **Feature First** architecture (`lib/features` with `auth`, `home`, `health`, `baby`, `appointments`, `emergency`, etc.).
- Integrated **Riverpod** with local dummy data in `lib/app/dummy_data/mock_data_providers.dart` (representing user profile, notifications, appointments, recovery checklist, etc).
- Set up routing using **GoRouter** in `lib/app/router/app_router.dart`, including a `ShellRoute` for the bottom navigation bar.
- Implemented the **Material 3 Design System** extracted from the Stitch project (colors, typography, rounded borders) in `lib/app/theme/app_theme.dart`.

## Screens Overview

### Onboarding & Authentication
- **Splash Screen**: Soft gradient, animated icon, automatically navigates to language selection.
- **Language Selection**: Clean, accessible language cards (English, Hindi, Marathi).
- **Onboarding**: 3-step carousel explaining app features with a skip/continue flow.
- **Login**: Dummy phone and OTP screens without authentication backend.

### Main Navigation (Bottom Bar)
- **Home**: Warm greeting, prominent Emergency button, week progress, baby size, and quick actions to other modules.
- **My Health**: Clean overview of health metrics (weight, BP, Hb, Sugar) with normal/warning indicators, and daily health suggestions. Links to the **Pregnancy Journey** (vertical timeline of all 40 weeks) and **Mother Recovery** (checklist and mood tracker).
- **Baby**: A toggleable screen. During pregnancy, it displays weekly baby development. Post-delivery, it switches to a newborn care dashboard.
- **Profile**: Displays user info (name, village, doctor, ASHA worker), emergency contacts, and settings link.

### Standalone Screens
- **Appointments**: Tabbed view for Upcoming and Completed visits.
- **Emergency**: Highly visible, large buttons to quickly call for help or view offline instructions.
- **Notifications**: Dummy local notifications for medicine reminders, health tips, and ASHA messages.
- **Community**: FAQ, educational video placeholders, and government scheme information.

## How to Test
You can run this app locally using:
```bash
flutter run
```
Since it uses Riverpod and GoRouter entirely locally with in-memory state, all tabs, toggles, checkboxes, and navigation routes will work seamlessly as a complete UI demonstration for your hackathon.

> [!TIP]
> Try tapping the **Sync icon** on the top right of the **Baby** tab to toggle the app's state between "Active Pregnancy" and "Post-Delivery Baby Care" modes!
