# HadyPay

**Send Money • Receive Trust** — a Flutter UI/UX prototype for a remittance
app. This is an MVP demo: **all data is mocked**, no real payments, accounts,
or backend are involved.

## Status

All 10 requested screens, the full Send Money flow, app wiring
(`lib/main.dart`), and Android platform scaffolding are complete. See
below for how to build it.

## Tech stack

- Flutter (Material 3), Dart null-safety (`>=3.3.0 <4.0.0`)
- State management: `provider` (`ChangeNotifier`)
- Architecture: Clean Architecture-flavored — `domain/` (entities +
  repository interface), `data/` (mock repository + seed data),
  `presentation/` (providers + screens)
- No backend, no persistence (`shared_preferences` intentionally not
  used — settings reset on app restart)
- Android only (no `ios/` directory)

## Demo credentials

- Enter any phone number on the Login screen.
- OTP code is always **`1234`**.

## Running locally

```bash
flutter pub get
flutter analyze
flutter run
```

## Building a release APK

```bash
flutter build apk --release
```

The output APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

> **Note on app icons:** the launcher icons (`assets/images/*.png`,
> `android/app/src/main/res/mipmap-*/ic_launcher*.png`) in this build are
> **placeholder brand-colored assets**, generated programmatically to match
> the documented HadyPay palette (navy `#162A4E` / teal `#19B38B`). The
> original uploaded logo file was not available when this build was
> assembled — swap in the real logo PNG at the same paths and re-run the
> icon generation step if you have it.

## Package name

`com.hadypay.app` — baked into the Kotlin source path
(`android/app/src/main/kotlin/com/hadypay/app/`) and the `applicationId`
in `android/app/build.gradle`. Don't change one without the other.
