//
//  TidalAPIEndpoints.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import Interchange

public enum TidalAPIEndpoints {

    /// A constant representing the TIDAL base URL for regular API requests
    ///
    public static let baseURL: URL = {
        guard let url = URL(string: "https://openapi.tidal.com/v2") else { fatalError("Invalid TIDAL API base URL!") }

        return url
    }()

    /// Creates an endpoint suitable to return the tracks for a given artist with a known TIDAL ID
    ///
    /// - Parameters:
    ///   - id: TIDAL artist ID string
    ///   - accessToken: TIDAL access token previously returned from the ``authToken`` authorization endpoint from `TidalAuthEndpoints`
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: RESTEndpoint
    ///
    /// ## Usage
    ///
    /// Use this endpoint with the ``TidalAPIEndpoints.baseURL`` to retrieve the top tracks for a given TIDAL artist ID with ``InterchangeManager``'s ``sendRequest(with: endpoint)``, setting the result type to the ``TidalArtistTracks`` model type.
    /// For example:
    ///
    /// ```swift
    /// let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)
    /// var accessToken: String?
    ///
    /// let endpoint = TidalAPIEndpoints.artistsTracks(withID: "SOME_ARTIST_ID",
    ///                                                accessToken: accessToken)
    /// do {
    ///     let rel: TidalArtistTracks = try await apiManager.sendRequest(with: endpoint)
    ///
    ///     guard let tracks = rel.included else { return }
    ///
    ///     print("TIDAL tracks: \(tracks)")
    /// } catch {
    ///     print("sendRequest error: \(error.localizedDescription)")
    /// }
    /// ```
    public static func artistsTracks(withID id: String,
                                     accessToken: String,
                                     countryCode: String = "US") -> RESTEndpoint {
        return RESTEndpoint(path: "/artists/\(id)/relationships/tracks",
                            headers: headers(withAccessToken: accessToken),
                            queryParameters: [URLQueryItem(name: "collapseBy", value: "FINGERPRINT"),
                                              URLQueryItem(name: "countryCode", value: countryCode),
                                              URLQueryItem(name: "include", value: "tracks")])
    }

    /// Creates an endpoint suitable to return album details for a known TIDAL album ID
    ///
    /// - Parameters:
    ///   - id: TIDAL album ID string
    ///   - accessToken: TIDAL access token previously returned from the ``authToken`` authorization endpoint from `TidalAuthEndpoints`
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: RESTEndpoint
    ///
    /// ## Usage
    ///
    /// Use this endpoint with the ``TidalAPIEndpoints.baseURL`` to retrieve the album details for a known TIDAL album ID with ``InterchangeManager``'s ``sendRequest(with: endpoint)``, setting the result type to the ``TidalAlbumResource`` model type.
    /// For example:
    ///
    /// ```swift
    /// let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)
    /// var accessToken: String?
    ///
    /// let endpoint = TidalAPIEndpoints.getAlbum(withID: "SOME_ALBUM_ID",
    ///                                           accessToken: accessToken)
    /// do {
    ///     let album: TidalAlbumResource = try await apiManager.sendRequest(with: endpoint)
    ///
    ///     print("TIDAL album details: \(album)")
    /// } catch {
    ///     print("sendRequest error: \(error.localizedDescription)")
    /// }
    /// ```
    public static func getAlbum(withID id: String,
                                accessToken: String,
                                countryCode: String = "US") -> RESTEndpoint {
        return RESTEndpoint(path: "/albums/\(id)",
                            headers: headers(withAccessToken: accessToken),
                            queryParameters: [URLQueryItem(name: "countryCode", value: countryCode)])
    }

    /// Creates an endpoint suitable to return album details for a known album UPC
    ///
    /// - Parameters:
    ///   - withUPC: album UPC (barcode number) string
    ///   - accessToken: TIDAL access token previously returned from the ``authToken`` authorization endpoint from `TidalAuthEndpoints`
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: RESTEndpoint
    ///
    /// ## Usage
    ///
    /// Use this endpoint with the ``TidalAPIEndpoints.baseURL`` to retrieve the album details for a known TIDAL album ID with ``InterchangeManager``'s ``sendRequest(with: endpoint)``, setting the result type to the ``TidalAlbumsResource`` model type.
    /// For example:
    ///
    /// ```swift
    /// let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)
    /// var accessToken: String?
    ///
    /// let endpoint = TidalAPIEndpoints.getAlbums(withUPC: "SOME_ALBUM_UPC",
    ///                                            accessToken: accessToken)
    /// do {
    ///     let album: TidalAlbumsResource = try await apiManager.sendRequest(with: endpoint)
    ///
    ///     print("TIDAL album details: \(album)")
    /// } catch {
    ///     print("sendRequest error: \(error.localizedDescription)")
    /// }
    /// ```
    public static func getAlbums(withUPC upc: String,
                                 accessToken: String,
                                 countryCode: String = "US") -> RESTEndpoint {
        return RESTEndpoint(path: "/albums",
                            headers: headers(withAccessToken: accessToken),
                            queryParameters: [URLQueryItem(name: "countryCode", value: countryCode),
                                              URLQueryItem(name: "filter[barcodeId]", value: upc)])
    }

    /// Creates an endpoint suitable to return track details for a known TIDAL track ID
    ///
    /// - Parameters:
    ///   - id: TIDAL track ID string
    ///   - accessToken: TIDAL access token previously returned from the ``authToken`` authorization endpoint from `TidalAuthEndpoints`
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: RESTEndpoint
    ///
    /// ## Usage
    ///
    /// Use this endpoint with the ``TidalAPIEndpoints.baseURL`` to retrieve the track details for a known TIDAL track ID with ``InterchangeManager``'s ``sendRequest(with: endpoint)``, setting the result type to the ``TidalTrackResource`` model type.
    /// For example:
    ///
    /// ```swift
    /// let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)
    /// var accessToken: String?
    ///
    /// let endpoint = TidalAPIEndpoints.getTrack(withID: "SOME_TRACK_ID",
    ///                                           accessToken: accessToken)
    /// do {
    ///     let track: TidalTrackResource = try await apiManager.sendRequest(with: endpoint)
    ///
    ///     print("TIDAL track details: \(track)")
    /// } catch {
    ///     print("sendRequest error: \(error.localizedDescription)")
    /// }
    /// ```
    public static func getTrack(withID id: String,
                                accessToken: String,
                                countryCode: String = "US") -> RESTEndpoint {
        return RESTEndpoint(path: "/tracks/\(id)",
                            headers: headers(withAccessToken: accessToken),
                            queryParameters: [URLQueryItem(name: "countryCode", value: countryCode)])
    }

    /// Creates an endpoint suitable to search the TIDAL catalog with a supported search query string
    ///
    /// - Parameters:
    ///   - withQuery: TIDAL search query string as described in the [TIDAL API documentation](https://tidal-music.github.io/tidal-api-reference/#/searchResults/get_searchResults__id_)
    ///   - type: One of the SearchType enum values representing a supported TIDAL item type to search as described in the [TIDAL API documentation](https://tidal-music.github.io/tidal-api-reference/#/searchResults/get_searchResults__id_)
    ///   - accessToken: TIDAL access token previously returned from the ``authToken`` authorization endpoint from `TidalAuthEndpoints`
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: RESTEndpoint
    ///
    /// ## Usage
    ///
    /// Use this endpoint with the ``TidalAPIEndpoints.baseURL`` to search the TIDAL catalog with ``InterchangeManager``'s ``sendRequest(with: endpoint)``, setting the result type to the ``TidalAlbumSearchResults`` model type.
    /// For example:
    ///
    /// ```swift
    /// let apiManager = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)
    /// var accessToken: String?
    ///
    /// let endpoint = TidalAPIEndpoints.search(withQuery: "Queen",
    ///                                         type: .artists,
    ///                                         accessToken: accessToken)
    /// do {
    ///     let searchResults: TidalAlbumSearchResults = try await apiManager.sendRequest(with: endpoint)
    ///
    ///     guard let artist = searchResults.artists?.items.first else {
    ///         print("Error: received value but albums is either missing or empty")
    ///         return nil
    ///     }
    ///
    ///     print("TIDAL artist: \(artist)")
    /// } catch {
    ///     print("sendRequest error: \(error.localizedDescription)")
    /// }
    /// ```
    public static func search(withQuery query: String,
                              type: SearchType,
                              accessToken: String,
                              countryCode: String = "US") -> RESTEndpoint {
        return RESTEndpoint(path: "/searchResults/\(query)",
                            headers: headers(withAccessToken: accessToken),
                            queryParameters: [URLQueryItem(name: "countryCode", value: countryCode),
                                              URLQueryItem(name: "explicitFilter", value: "INCLUDE"),
                                              URLQueryItem(name: "include", value: type.rawValue)])
    }

    public enum SearchType: String {
        case albums
        case artists
        case playlists
        case topHits
        case tracks
        case videos
    }

    private static func headers(withAccessToken accessToken: String) -> [String : String] {
        var allHeaders: [String : String] = [:]
        if !accessToken.isEmpty {
            allHeaders["Authorization"] = "Bearer \(accessToken)"
        }
        allHeaders["Accept"] = "application/vnd.api+json"
        return allHeaders
    }
}
