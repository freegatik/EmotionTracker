<img src="Aura/Resources/Assets.xcassets/AppIcon/AppIcon.appiconset/180.png" width="200">

# Aura

![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![Release](https://img.shields.io/badge/release-v1.0.0-green)

iOS app: daily emotions, notes, tags, statistics, settings (notifications, Face ID).

## Requirements

- Xcode 16+ (app target iOS 17.6+, Swift 5)
- Apple Developer team in Xcode for a physical device

## Run

1. Open `Aura.xcodeproj` (SnapKit resolves on first open).
2. Scheme **Aura**, pick simulator or device.
3. Signing: target Aura → your team (bundle id `solovev.*`).
4. Run (⌘R).

### Unit tests (CLI)

```bash
xcodebuild test \
  -project Aura.xcodeproj \
  -scheme Aura \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:AuraTests
```

### All tests — unit + UI (CLI)

Same as CI `tests` job (full scheme):

```bash
xcodebuild test \
  -project Aura.xcodeproj \
  -scheme Aura \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

Pick a `-destination` from `xcodebuild -showdestinations` if needed.

### SwiftLint

```bash
brew install swiftlint && swiftlint
```

## Tests

| Target | What |
|--------|------|
| `AuraTests` | View models (`Settings`, `Log`, notes, statistics helpers), `CoreDataService` (in-memory stack), **coordinators** (`AppCoordinator`, `LogCoordinator`, `TabBarCoordinator`), Core Data **child-context** integration. |
| `AuraUITests` | Smoke: welcome, log, tab navigation (statistics, settings), add-note flow, **settings switches**. |

Deeper UI (full statistics pager, every coordinator branch) is still lighter than core VM + navigation tests; expand with accessibility IDs + UI tests as flows stabilize.

## Layout

UIKit, coordinators, MVVM where used. Services wired through `AppDependencies` → `AppCoordinator`. Details: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## CI

- `.github/workflows/ios-ci.yml`: on push/PR to `main` or `master` — parallel jobs: SwiftLint, `xcodebuild analyze`, Debug build, Release (Simulator) build, and `xcodebuild test` for the whole shared scheme (`AuraTests` + `AuraUITests`). **Xcode 16+** is selected for build/test/analyze (the `.xcodeproj` uses **objectVersion 77**, which Xcode 15 cannot open). Tests run with **code coverage**; the job uploads **`TestResults.xcresult`** as an artifact and prints an **`xccov`** summary on the run’s **Summary** tab.

See [CONTRIBUTING.md](CONTRIBUTING.md) for review and quality expectations.

Dependabot (`.github/dependabot.yml`) bumps **GitHub Actions** dependencies weekly. SwiftPM packages (e.g. SnapKit) live in the Xcode workspace only — Dependabot does not read them without a root `Package.swift`; update those via Xcode or a resolved-file PR.

## Optional local config

Copy `Config/Local.xcconfig.example` → `Config/Local.xcconfig` (gitignored) if you wire xcconfigs later. Do not commit secrets.

## Changelog

[CHANGELOG.md](CHANGELOG.md)

## Screenshots

### Welcome

<p align="center">
    <img src="Aura/Resources/Previews/1.png" width="200">
</p>

### Log

<p align="center">
    <img src="Aura/Resources/Previews/2.png" width="200">
    <img src="Aura/Resources/Previews/3.png" width="200">
    <img src="Aura/Resources/Previews/4.png" width="200">
</p>

### Add & edit note

<p align="center">
    <img src="Aura/Resources/Previews/5.png" width="200">
    <img src="Aura/Resources/Previews/6.png" width="200">
</p>

### Statistics

<p align="center">
    <img src="Aura/Resources/Previews/7.png" width="200">
    <img src="Aura/Resources/Previews/8.png" width="200">
    <img src="Aura/Resources/Previews/9.png" width="200">
    <img src="Aura/Resources/Previews/10.png" width="200">
</p>

### Settings

<p align="center">
    <img src="Aura/Resources/Previews/11.png" width="200">
</p>

## License

[LICENSE](LICENSE)
