# Architecture

## Layout

| Area | Role |
|------|------|
| `App/` | `SceneDelegate`, `AppDependencies`, `AppCoordinator` |
| `Presentation/` | UIKit + coordinators + view models |
| `Data/` | Core Data + service protocols/implementations |
| `Utils/`, `Extensions/` | shared helpers |

Coordinators use `Coordinator`; view models talk to `CoreDataServiceProtocol` and other protocols, not concrete types from `Data/` except via injection.

Folders are the module boundary (no SPM split yet).

## Navigation

`AppCoordinator` → welcome / biometric / tab root. Feature coordinators (`LogCoordinator`, …) own push/present.

## Data

`CoreDataService` implements `CoreDataServiceProtocol`. Unit tests use `MockCoreDataService`. Save errors: log + rollback. Store load failure: log + `fatalError`.

No network layer.

## Logging

`AppLog` wraps `os.Logger` (`Persistence`, `Data`). Avoid `print` for diagnostics you care about in builds.

## Tests

- **Unit** (`AuraTests`): view models (`Settings`, `Log`, notes, statistics helpers), `CoreDataService` against an in-memory stack, **coordinators** (`AppCoordinator`, `LogCoordinator`, `TabBarCoordinator`), and **Core Data concurrency** (`performAndWait` under parallel load).
- **UI** (`AuraUITests`): welcome/log smoke, tab navigation, add-note flow, settings switches.

CI runs SwiftLint, static analysis, Debug/Release simulator builds, and the full test action (unit + UI) in separate jobs — see `.github/workflows/ios-ci.yml`.

## Composition root

`AppDependencies` is the app **composition root**: `CoreDataService`, `BiometricService`, and `NotificationService` are created in `production()` and passed through `AppCoordinator` → `WelcomeCoordinator` / `TabBarCoordinator` → feature coordinators. `LogViewController` receives a `LogViewModel` built with the shared `CoreDataServiceProtocol`; `SettingsViewController` gets a `SettingsViewModel` built from the same graph. Use `AppDependencies.testing(...)` in unit tests to inject mocks.

## Build

Shared scheme: `Aura.xcodeproj/xcshareddata/xcschemes/Aura.xcscheme`. SnapKit via SPM (`Package.resolved` in workspace — commit it). Signing: Xcode team on the app target.
