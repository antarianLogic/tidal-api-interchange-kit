# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- contributing guidelines (`CONTRIBUTING.md`)
- this `CHANGELOG.md` file

### Changed
- Updated `README.md` with basic documentation for public release

### Deprecated
TBD

### Removed
TBD

### Fixed
TBD

### Security
TBD

## [0.1.1] - 2026-02-20

### Added
- expired auth. token logic to `TidalAPIWorker`

## [0.1.0] - 2026-02-19

### Added
- `TidalAPIWorker.swift` - top-level interface to provide convenience functions and manage authorization
- `Auth` folder - with authorization endpoints, codable models, and error enum
- `API` folder - with regular API endpoints, codable models, and error enum
- `Tests/TidalAPIInterchangeKitTests` folder - all unit tests
- `TidalAPIDataPresets` folder - mock data for testing and previews fed by JSON from real responses
