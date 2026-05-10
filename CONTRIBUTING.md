# Contributing

## Reviews

Treat every pull request as a place to show how you think about iOS: boundaries (protocols / DI), testability, and user-visible behavior. Prefer small, focused changes with a clear “why” in the description.

## Quality bar

- Run **SwiftLint** and **tests** locally before pushing (`README` has CLI examples).
- New feature logic should come with **unit tests** where mocking is practical; navigation-heavy flows should have **coordinator tests** or **UI smoke tests** with stable accessibility identifiers.
- Core Data changes: exercise **in-memory** tests and consider concurrency (`performAndWait` / context confinement).

## Releases

Tagging and App Store / TestFlight flows are not automated in this repo. Document notable changes in `CHANGELOG.md` when behavior or requirements visible to users or integrators change.
