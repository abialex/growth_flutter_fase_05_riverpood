# Changelog

All notable changes to this package are documented in this file.

## [Unreleased]

### Changed

- Updated the package constraints to Dart 3.9.2 and Flutter 3.35.0.
- Disabled router diagnostics in release builds.
- Removed the unused route-to-path callback from `AppGoRouter`.
- Restricted the public `go_router` exports to the types required by consumers.
- Updated the README to document the current public API.
- Corrected the local installation path and completed the imports in the README
  examples.

### Fixed

- Pass the complete matched location to the route mapper so parameterized
  routes are identified correctly.
- Preserve the resolved route path in custom page settings for pop events.
