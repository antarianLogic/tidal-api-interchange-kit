# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-03-10

### Added
- `TidalArtistAttributes`
- `TidalArtwork`
- `TidalArtworkAttributes`
- `TidalArtworkFile`
- `TidalArtworkFileMeta`
- `TidalArtworkVisualMetadata`
- `TidalIncludedType`
- `TidalPlaylist`
- `TidalPlaylistAttributes`
- `TidalVideo`
- `TidalVideoAttributes`
- `TidalAlbumRelationships`
- `TidalAlbumItemRelationship`
- `TidalAlbumItemResource`
- `TidalAlbumItemMeta`
- `searchArtists(withName:...` in `TidalAPIWorker`
- `searchPlaylists(withName:...` in `TidalAPIWorker`
- `searchTopHits(withText:...` in `TidalAPIWorker`
- `searchTracks(withTitle:...` in `TidalAPIWorker`
- `searchVideos(withTitle:...` in `TidalAPIWorker`

### Changed
- `TidalAPIEndpoints`: `getAlbums(withUPC: String...` changed to `getAlbums(withUPCs albumUPCs: [String]...`
- `TidalAPIEndpoints`: `artistsTracks(withID:...` changed to `artistTracks(withID...`
- `TidalAPIWorker`: `getTracksForArtist` now returns `TidalArtistTracks`
- `TidalAPIWorker`: `getAlbum(withID:...` now returns tracks and artwork
- `TidalResource` to `TidalArtist`
- `TidalArtistTracks`: added `included` property
- `TidalAlbumSearchResults` to `TidalSearchResults`
- `TidalAlbumAttributes`: renamed some properties and added `releaseDate` getter
- `TidalTrackAttributes`: renamed some properties and added `creationDate` getter
- `TidalAlbumResource`: added `trackAt(volumeNumber:trackNumber:)`
- `TidalAlbum`: added `relationships` property

## [0.2.0] - 2026-02-24

### Added
- contributing guidelines (`CONTRIBUTING.md`)
- this `CHANGELOG.md` file

### Changed
- `README.md` adding basic documentation for public release

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
