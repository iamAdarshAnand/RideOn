# RIDEON — Flutter Bike Taxi, Auto & Cab Booking App Source Code

![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter)
![Backend](https://img.shields.io/badge/Backend-Node.js%20%2B%20Express-339933?logo=nodedotjs)
![Database](https://img.shields.io/badge/Database-SQLite-003B57?logo=sqlite)
![Status](https://img.shields.io/badge/Status-Development%20Prototype-orange)

**RIDEON** is a Flutter-based, open-source ride-hailing application prototype for learning how to build a bike taxi booking app, auto-rickshaw booking app, and cab reservation system. Explore a passenger interface, captain (driver) workflow, Node.js REST API, SQLite database, and admin dashboard.

**Project links:** [Source code](https://github.com/iamAdarshAnand/RideOn) · [Issues](https://github.com/iamAdarshAnand/RideOn/issues) · [Contributing](CONTRIBUTING.md)



**Open-source-style ride-hailing development prototype for Android, Node.js and SQLite.** Build and learn from a passenger booking app, captain (driver) workflow, REST API and web admin dashboard.

> **Status: v0.1 development prototype — not production-ready.** RIDEON is independently branded and is **not affiliated with Rapido, Ola, Uber or any other ride-hailing company**. Brand names appear here only as comparisons to help developers understand the project category.

## Who is this for?

Developers in India and worldwide exploring:
- Flutter bike taxi booking app source code (Rapido-style concept)
- Ola/Uber-like taxi booking system architecture
- Ride-hailing app development for Android
- Auto-rickshaw, bike taxi and cab booking software
- Passenger app, driver/captain app and admin dashboard
- Node.js Express REST API with SQLite
- Mobility, transportation, on-demand services and dispatch systems

## What works today?

| Module | Available in v0.1 |
| --- | --- |
| Passenger Android UI | Enter pickup/destination, select bike/auto/cab, create a demo booking, see recent trips |
| Captain Android UI | View demo requests, accept rides, start and complete trips |
| Admin web UI | Trip counts and trip list, register demo drivers, toggle approval records |
| Express API | Ride creation, ride state transitions, driver endpoints, health endpoint |
| SQLite | Local persistence for rides and drivers |

**Not implemented:** real-time GPS, mapping, routing, actual dispatch or matching, secure accounts and OTP, KYC, payments, production authorization, notifications, background location, fare calculation by distance, and ride safety systems. Fixed demonstration fares are used. The admin panel and API have no authentication: **do not expose them to the public internet**.

## Tech stack

- Flutter + Dart for Android passenger/captain prototype (both views in one app)
- Node.js 20+, Express REST API
- SQLite via better-sqlite3
- Vanilla HTML/CSS/JavaScript for local admin dashboard

## Repository structure

```text
RIDEON/
├── mobile/
│   ├── lib/main.dart
│   └── pubspec.yaml
├── server/
│   ├── index.js
│   └── package.json
├── admin/
│   └── index.html
├── CONTRIBUTING.md
├── .gitignore
└── README.md
```

## Quick start

### 1. Start backend

Install Node.js 20+ and native compilation tools for better-sqlite3.

```bash
git clone https://github.com/iamAdarshAnand/RIDEON.git
cd RIDEON/server
npm install
npm start
```

Check http://localhost:3000/api/health for the local API response.

### 2. Run Android client

Install Flutter stable, Android Studio, Android SDK and an Android emulator. This repository includes the Flutter Dart app and dependencies, but **not the generated Android platform scaffold**. Generate it locally:

```bash
cd ../mobile
flutter create --platforms android .
flutter pub get
flutter run --dart-define=API_URL=http://10.0.2.2:3000
```

The Android emulator reaches the host computer using `10.0.2.2`. On a physical device use your computer's LAN IP, ensuring the local API is reachable.

For local HTTP development, edit `mobile/android/app/src/main/AndroidManifest.xml`:
- Add `<uses-permission android:name="android.permission.INTERNET"/>` inside the `<manifest>` element.
- Add `android:usesCleartextTraffic="true"` to the `<application>` element.

**Use HTTPS in production** and remove the cleartext allowance.

Build a local debug APK:

```bash
flutter build apk --debug --dart-define=API_URL=http://10.0.2.2:3000
```

Output: `mobile/build/app/outputs/flutter-apk/app-debug.apk`. No prebuilt APK is provided, and this build has not been device-tested.

### 3. Run local admin panel

In a separate terminal:

```bash
cd RIDEON/admin
python3 -m http.server 8080
```

Open http://localhost:8080. The page expects the local API on port 3000. **Never deploy the unauthenticated admin panel publicly.**

## API reference (development only)

| Method | Endpoint | Purpose |
| --- | --- | --- |
| GET | `/api/health` | Health check |
| GET | `/api/rides` | Recent rides |
| POST | `/api/rides` | Create demo ride |
| POST | `/api/rides/:id/accept` | Accept requested ride |
| POST | `/api/rides/:id/start` | Start accepted ride |
| POST | `/api/rides/:id/complete` | Complete in-progress ride |
| POST | `/api/rides/:id/cancel` | Cancel requested ride |
| GET | `/api/admin/stats` | Counts |
| GET | `/api/admin/drivers` | Driver records |
| POST | `/api/admin/drivers` | Create driver record |
| POST | `/api/admin/drivers/:id/approve` | Flag driver as approved |

## Roadmap

- [ ] Secure role-based login, OTP, rate limiting and authorization
- [ ] Map integration, GPS, geocoding and route distance estimates
- [ ] Real-time captain presence, dispatch and matching
- [ ] Driver onboarding and genuine identity verification
- [ ] Payment gateway, UPI and cash trip settlement
- [ ] Push notifications and ride status updates
- [ ] Safety tools, trip sharing and emergency support
- [ ] Internationalization, accessibility and tests
- [ ] Separate production passenger and captain apps
- [ ] Production deployment, monitoring and transport compliance

## Find RIDEON on GitHub

Relevant developer searches include **Flutter taxi booking app**, **bike taxi booking app source code**, **ride-hailing application GitHub**, **driver passenger booking system**, **Node.js taxi booking backend**, **SQLite ride management system**, **Flutter Android mobility app**, and **ride-sharing app development tutorial**.

RIDEON is an educational starting point, not a finished commercial transportation platform. Features described in the roadmap are not implemented in v0.1.

## Search and discovery

**India:** bike taxi app development, Rapido-like app architecture, Ola-like taxi booking source code, Flutter cab booking app India, auto rickshaw booking app.

**International:** ride-sharing app source code, Uber-like Flutter app architecture, taxi dispatch platform, driver passenger admin system, on-demand mobility app, transportation booking backend.

These are project descriptors, not claims of affiliation or feature parity.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Do not commit credentials, personal customer data, local databases or signing keys.

## Maintainer

[Adarsh Anand](https://github.com/iamAdarshAnand) — AI/ML and full-stack developer.

**Disclaimer:** Educational and development use. Confirm transport licensing, privacy, payment and safety obligations before any real-world service launch.
