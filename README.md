# TIDAL API Interchange Kit

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20visionOS-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager)

## A Swift package containing API methods and response models for interacting with the TIDAL [API](https://tidal-music.github.io/tidal-api-reference) via [Interchange](https://github.com/antarianLogic/interchange)

---

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 6.0+
- Xcode 14.0+

## Installation

Do ONE of the following, depending on whether you are adding this package as a dependency to an app-level Xcode project or another Swift Package.

### App-level Projects

Add a package dependency for `https://github.com/antarianLogic/tidal-api-interchange-kit` to your project through Xcode. For more information see [Adding Package Dependencies](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app).

### Swift Packages

Add a package dependency for `tidal-api-interchange-kit` to your `Package.swift`:

```swift
dependencies: [
    // ...
    .package(url: "https://github.com/antarianLogic/tidal-api-interchange-kit", from: "0.2.0")
]
```

And add the `TidalAPIInterchangeKit` product to your target dependencies in `Package.swift` as well:

```swift
targets: [
    .target(name: "YOUR_TARGET_NAME",
            dependencies: [
                // ...
                .product(name: "TidalAPIInterchangeKit", package: "tidal-api-interchange-kit")
            ]),
    // ...
]
```

## Overview

This package contains a collection of TIDAL API endpoint specifications in the form of `RESTEndpoint` structs to be used with [Interchange](https://github.com/antarianLogic/interchange).
It also contains the `Codable` model types to be returned by `InterchangeManager`s generic `sendRequest` function when using the corresponding `RESTEndpoint` struct.
For each endpoint specification, there is a convenience static function in either `TidalAuthEndpoints` or `TidalAPIEndpoints` that returns a fully-populated `RESTEndpoint` struct.
Finally, a worker/manager is provided called `TidalAPIWorker` that ties it all together by handling authorization internally and providing convenience functions for each supported API call.

Consumers of this package may either simply use the high-level `TidalAPIWorker` for ease of use or chose to use the lower-level `TidalAPIEndpoints` functions for more control with a separate `InterchangeManager` for authorization and API calls, and using `sendRequest` to make the actual network calls.

Current TIDAL Authorization endpoints (`https://auth.tidal.com/v1/...`) supported are:

| Path           | `TidalAuthEndpoints` Method | `sendRequest` Return Type |
| -------------- | --------------------------- | ------------------------- |
| /oauth2/token  | `authToken`                 | `TidalAuthResponse`       |

Current TIDAL API endpoints (`https://openapi.tidal.com/v2/...`) supported are:

| Path                   | `TidalAPIEndpoints` Method | `sendRequest` Return Type | `TidalAPIWorker` Method | `TidalAPIWorker` Return Type |
| ---------------------- | -------------------------- | ------------------------- | ----------------------- | ---------------------------- |
| /artists/{id}          | `artistTracks`             | `TidalArtistTracks`       | `getTracksForArtist`    | `TidalArtistTracks`          |
| /albums/{id}           | `getAlbum`                 | `TidalAlbumResource`      | `getAlbum`              | `TidalAlbum`                 |
| /albums                | `getAlbums`                | `TidalAlbumsResource`     | `getAlbums`             | `[TidalAlbum]`               |
| /tracks/{id}           | `getTrack`                 | `TidalTrackResource`      | `getTrack`              | `TidalTrack`                 |
| /searchResults/{query} | `search`                   | `TidalAlbumSearchResults` | `searchAlbums`          | `[TidalAlbum]`               |

## Future Development

The official documentation for the TIDAL [API](https://tidal-music.github.io/tidal-api-reference) shows many more endpoints available than in the tables above.
This package was originally made to support looking up TIDAL IDs in a real-world app to determine if streaming is supported for a given artist, release, or track and to possibly show metadata and artwork during streaming.
It is intended (and actually recommended by TIDAL itself) that the TIDAL SDK be used for actual streaming in apps so streaming support and other features such as retrieving TIDAL user data were not added to this package initially.
However, this package, besides serving as a public example of the use of the `Interchange` package, might of course be useful for other real-world apps as well.
Therefore, other TIDAL endpoints including user data (including auth. code flow and refresh token support) may certainly be added in the future and PRs are welcome!

## Examples

### Authorization (Client Credentials Flow)

If the `TidalAPIWorker` is used, authorization is handled automatically but the TIDAL client ID and client secret must be passed during initialization.

To handle authorization a bit more manually, use the `getAuthToken` of `TidalAuthEndpoints` as demonstrated below.

```swift
    import Interchange
    import TidalAPIInterchangeKit

    let authManager = InterchangeManager(baseURL: TidalAuthEndpoints.baseURL)

    var accessToken: String?
    var tokenExpiration = Date.distantPast

    func checkAuth() async -> Bool {
        guard accessToken == nil || tokenExpiration.timeIntervalSinceNow < 60 else { return true }

        await authorize()

        return accessToken != nil
    }

    func authorize() async {
        let endpoint = TidalAuthEndpoints.authToken(clientID: "YOUR_CLIENT_ID",
                                                    clientSecret: "YOUR_CLIENT_SECRET")
        do {
            let response: TidalAuthResponse = try await authManager.sendRequest(with: endpoint)

            guard response.tokenType.lowercased() == "bearer" else {
                print("Error: unexpected tokenType type: \(response.tokenType)")
                return
            }

            accessToken = response.accessToken
            tokenExpiration = Date(timeIntervalSinceNow: TimeInterval(response.expiresIn))
        } catch {
            print("Auth error: \(error.localizedDescription)")
        }
    }
```

If the above code was used, `checkAuth()` would then be called and checked before every regular API call using the manual method (when not using `TidalAPIWorker`).

### Get Album by TIDAL ID

#### `TidalAPIWorker` Approach

```swift
    import TidalAPIInterchangeKit

    let worker = TidalAPIWorker(clientID: "YOUR_CLIENT_ID",
                                clientSecret: "YOUR_CLIENT_SECRET")

    // Make TIDAL album lookup call for TIDAL ID (in async context)...
    do {
        let album = try await worker.getAlbum(withID: "SOME_TIDAL_ALBUM_ID")

        print("Album title: \(album?.attributes?.title ?? "nil")")
        print("Album release date: \(album.attributes?.releaseDate ?? "nil")")
    } catch {
        print("Get album error: \(error.localizedDescription)")
    }
```

#### Manual Approach

```swift
    import Interchange
    import TidalAPIInterchangeKit

    let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)

    // First check TIDAL authorization...
    guard await checkAuth(),
          let accessToken else {
        print("Error: TIDAL authorization failed")
        return
    }
    // Set up endpoint
    let endpoint = TidalAPIEndpoints.getAlbum(withID: "SOME_TIDAL_ALBUM_ID",
                                              accessToken: accessToken)
    // Now make actual network call (in async context)...
    do {
        let albumRes: TidalAlbumResource = try await apiManager.sendRequest(with: endpoint)
        let album = albumRes.data

        print("Album title: \(album.attributes?.title ?? "nil")")
        print("Album release date: \(album.attributes?.releaseDate ?? "nil")")
    } catch {
        print("getAlbum error: \(error.localizedDescription)")
    }
```

### Find Albums with UPCs

#### `TidalAPIWorker` Approach

```swift
    import TidalAPIInterchangeKit

    let worker = TidalAPIWorker(clientID: "YOUR_CLIENT_ID",
                                clientSecret: "YOUR_CLIENT_SECRET")

    // In async context:
    do {
        let albums = try await worker.getAlbums(withUPCs: ["SOME_ALBUM_UPC"])

        print("Albums with UPCs: \(albums)")
    } catch {
        print("Get albums with UPCs error: \(error.localizedDescription)")
    }
```

#### Manual Approach

```swift
    import Interchange
    import TidalAPIInterchangeKit

    let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)

    // First check TIDAL authorization...
    guard await checkAuth(),
          let accessToken else {
        print("Error: TIDAL authorization failed")
        return
    }
    // Set up endpoint
    let endpoint = TidalAPIEndpoints.getAlbums(withUPCs: ["SOME_ALBUM_UPC"],
                                               accessToken: accessToken)
    // Now make actual network call (in async context)...
    do {
        let albumsRes: TidalAlbumsResource = try await apiManager.sendRequest(with: endpoint)
        let albums = albumsRes.data

        print("Albums with UPCs: \(albums)")
    } catch {
        print("sendRequest error: \(error.localizedDescription)")
    }
```

### Get Track by TIDAL ID

#### `TidalAPIWorker` Approach

```swift
    import TidalAPIInterchangeKit

    let worker = TidalAPIWorker(clientID: "YOUR_CLIENT_ID",
                                clientSecret: "YOUR_CLIENT_SECRET")

    // In async context:
    do {
        let track = try await worker.getTrack(withID: "SOME_TRACK_ID")

        print("Track title: \(track.attributes?.title ?? "nil")")
    } catch {
        print("Get track error: \(error.localizedDescription)")
    }
```

#### Manual Approach

```swift
    import Interchange
    import TidalAPIInterchangeKit

    let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)

    // First check TIDAL authorization...
    guard await checkAuth(),
          let accessToken else {
        print("Error: TIDAL authorization failed")
        return
    }
    // Set up endpoint
    let endpoint = TidalAPIEndpoints.getTrack(withID: "SOME_TRACK_ID",
                                              accessToken: accessToken)
    // Now make actual network call (in async context)...
    do {
        let trackRes: TidalTrackResource = try await apiManager.sendRequest(with: endpoint)
        let track = trackRes.data

        print("Track title: \(track.attributes?.title ?? "nil")")
    } catch {
        print("sendRequest error: \(error.localizedDescription)")
    }
```

### Album Search

#### `TidalAPIWorker` Approach

```swift
    import TidalAPIInterchangeKit

    let worker = TidalAPIWorker(clientID: "YOUR_CLIENT_ID",
                                clientSecret: "YOUR_CLIENT_SECRET")

    // In async context:
    do {
        let albums = try await worker.searchAlbums(withTitle: "Nevermind", artistName: "Nirvana")

        print("Albums: \(albums)")
    } catch {
        print("Search albums error: \(error.localizedDescription)")
    }
```

#### Manual Approach

```swift
    import Interchange
    import TidalAPIInterchangeKit

    let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)

    // First check TIDAL authorization...
    guard await checkAuth(),
          let accessToken else {
        print("Error: TIDAL authorization failed")
        return
    }
    // Set up endpoint, including URL encoding spaces and other special characters in query since it will be part of path
    let rawQueryString = "Nevermind - Nirvana"
    guard let queryString = rawQueryString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
        print("Error: Could not escape search query string: \"\(rawQueryString)\"")
        return
    }
    let endpoint = TidalAPIEndpoints.search(withQuery: queryString,
                                            type: .albums,
                                            accessToken: accessToken)
    // Now make actual network call (in async context)...
    do {
        let searchResults: TidalAlbumSearchResults = try await apiManager.sendRequest(with: endpoint)
        let albums = searchResults.included

        print("Albums: \(albums)")
    } catch {
        print("sendRequest error: \(error.localizedDescription)")
    }
```

### Top Tracks for Artist

#### `TidalAPIWorker` Approach

```swift
    import TidalAPIInterchangeKit

    let worker = TidalAPIWorker(clientID: "YOUR_CLIENT_ID",
                                clientSecret: "YOUR_CLIENT_SECRET")

    // In async context:
    do {
        let artistAndTracks = try await worker.getTracksForArtist(withID: "SOME_ARTIST_ID")

        print("Artist and tracks: \(artistAndTracks)")
    } catch {
        print("Get tracks for artist error: \(error.localizedDescription)")
    }
```

#### Manual Approach

```swift
    import Interchange
    import TidalAPIInterchangeKit

    let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)

    // First check TIDAL authorization...
    guard await checkAuth(),
          let accessToken else {
        print("Error: TIDAL authorization failed")
        return
    }
    // Set up endpoint
    let endpoint = TidalAPIEndpoints.artistTracks(withID: "SOME_TRACK_ID",
                                                  accessToken: accessToken)
    // Now make actual network call (in async context)...
    do {
        let artistTracks: TidalArtistTracks = try await apiManager.sendRequest(with: endpoint)
        let tracks = artistTracks.included

        print("Tracks: \(tracks)")
    } catch {
        print("sendRequest error: \(error.localizedDescription)")
    }
```

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Carl Sheppard** - [Antarian Logic LLC](https://github.com/antarianLogic)

## Support

- 📫 Report issues on [GitHub Issues](https://github.com/antarianLogic/tidal-api-interchange-kit/issues)
- 💬 Ask questions in [GitHub Discussions](https://github.com/antarianLogic/tidal-api-interchange-kit/discussions)
- ⭐ Star the repo if you find it useful!
