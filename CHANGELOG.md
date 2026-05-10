# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Shared scheme `Aura` for CI/clones.
- GitHub Actions: SwiftLint, static analysis, Debug/Release simulator builds, unit + UI tests.
- `AppDependencies`, `AppLog` (`os.Logger`).
- `docs/ARCHITECTURE.md`; `Config/Local.xcconfig.example`.
- Unit tests for `AppCoordinator`, `LogCoordinator`, `TabBarCoordinator`; Core Data child-context integration test; settings tab UI smoke; `CONTRIBUTING.md`.
- `AppDependencies.testing(...)` composition-root helper for tests.

### Changed

- `AppDependencies` carries **notification**, Core Data, and biometric services; coordinators pass them into `SettingsViewModel` and `LogViewModel` so settings and log share one injected `CoreDataServiceProtocol` per launch.
- `AppCoordinator` takes `AppDependencies` instead of constructing services in `init`.
- Core Data: save failures log + rollback; broken `UserSettings` fetch creates defaults + log; emotion save uses `Logger` instead of `print`.
- Store load: fault log, then `fatalError`.
