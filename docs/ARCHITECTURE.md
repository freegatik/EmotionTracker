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

- **Unit** (`AuraTests`): `SettingsViewModel` + notifications, `LogViewModel`-related cases with mocks.
- **UI** (`AuraUITests`): welcome/log smoke; template tests in default UITest target.

CI runs unit tests only (see `.github/workflows/ios.yml`).

## Build

Shared scheme: `Aura.xcodeproj/xcshareddata/xcschemes/Aura.xcscheme`. SnapKit via SPM (`Package.resolved` in workspace — commit it). Signing: Xcode team on the app target.
