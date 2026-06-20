# HomeFit Trainer

HomeFit is a Flutter workout companion with guided onboarding, workout plans,
exercise details, a workout timer, progress tracking, and profile preferences.

Phase 2 adds Firebase-backed accounts and fitness history, adaptive workout
generation, Lottie-ready animation rendering, voice coaching, health
calculators, and persistent dark mode.

## Included flows

- Branded splash and demo login
- Gender, fitness goal, and experience-level setup
- Personalized home dashboard
- Workout categories and exercise details
- Working countdown timer
- Weekly and monthly progress views
- Profile and training preferences
- Email/password and Google authentication
- Firestore profile, weight, streak, and workout history services
- Beginner, intermediate, and advanced AI trainer plans
- Text-to-speech instructions and countdown coaching
- BMI and calories-burned calculators
- Light and dark themes

The current male and female exercise guide images are used as visual
placeholders. Individual GIF or Lottie exercise animations can be introduced
later without changing the navigation structure.

Firebase project secrets are intentionally not committed. See
[`FIREBASE_SETUP.md`](FIREBASE_SETUP.md) to connect a Firebase project. Without
those files the app runs in a clearly labelled demo mode.

## Run locally

```shell
flutter pub get
flutter run
```

For the demo login, enter any valid email address and a password containing at
least six characters.
