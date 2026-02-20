//
//  TidalAPIWorker.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/14/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import Interchange

public actor TidalAPIWorker {

    /// Creates a new worker instance.
    ///
    /// - Parameters:
    ///   - clientID: TIDAL Client ID string copied from the TIDAL developer dashboard
    ///   - clientSecret: TIDAL Client Secret string copied from the TIDAL developer dashboard
    ///   - alternateAuthManager: A optional InterchangeManager to use for authorization requests. Omit to use the default for production or inject a MockInterchangeManager for testing or previews.
    ///   - alternateAPIManager: A optional InterchangeManager to use for regular API requests. Omit to use the default for production or inject a MockInterchangeManager for testing or previews.
    ///
    public init(clientID: String,
                clientSecret: String,
                alternateAuthManager: InterchangeManaging = InterchangeManager(baseURL: TidalAuthEndpoints.baseURL),
                alternateAPIManager: InterchangeManaging = InterchangeManager(baseURL: TidalAPIEndpoints.baseURL)) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authManager = alternateAuthManager
        self.apiManager = alternateAPIManager
    }

    private let clientID: String
    private let clientSecret: String
    private let authManager: InterchangeManaging
    private let apiManager: InterchangeManaging
    private var accessToken: String?
    private var tokenExpiration = Date.distantPast

    /// Returns the tracks for a given artist with a known TIDAL ID
    ///
    /// - Parameters:
    ///   - withID: TIDAL artist ID string
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: array of TidalTrack
    ///
    public func getTracksForArtist(withID artistID: String,
                                   countryCode: String = "US") async throws -> [TidalTrack] {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid artist ID...
        let trimmedID = artistID.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedID.isEmpty else {
            throw TidalAPIError.invalidInput(artistID)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.artistsTracks(withID: trimmedID,
                                                       accessToken: accessToken,
                                                       countryCode: countryCode)
        let artistTracks: TidalArtistTracks = try await apiManager.sendRequest(with: endpoint)

        guard let tracks = artistTracks.included,
              !tracks.isEmpty else {
            throw TidalAPIError.noItemsFound
        }
        // Return just the track resources
        return tracks
    }

    /// Returns album details for a known TIDAL album ID
    ///
    /// - Parameters:
    ///   - withID: TIDAL album ID string
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: TidalAlbum
    ///
    public func getAlbum(withID albumID: String,
                         countryCode: String = "US") async throws -> TidalAlbum {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid album ID...
        let trimmedID = albumID.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedID.isEmpty else {
            throw TidalAPIError.invalidInput(albumID)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.getAlbum(withID: trimmedID,
                                                  accessToken: accessToken,
                                                  countryCode: countryCode)
        let albumRes: TidalAlbumResource = try await apiManager.sendRequest(with: endpoint)

        return albumRes.data
    }

    /// Returns track details for a known TIDAL track ID
    ///
    /// - Parameters:
    ///   - withID: TIDAL track ID string
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: TidalTrack
    ///
    public func getTrack(withID trackID: String,
                         countryCode: String = "US") async throws -> TidalTrack {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid track ID...
        let trimmedID = trackID.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedID.isEmpty else {
            throw TidalAPIError.invalidInput(trackID)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.getTrack(withID: trimmedID,
                                                  accessToken: accessToken,
                                                  countryCode: countryCode)
        let trackRes: TidalTrackResource = try await apiManager.sendRequest(with: endpoint)

        return trackRes.data
    }

    /// Retrieves the TIDAL catalog for albums with a known UPC code
    ///
    /// - Parameters:
    ///   - withUPC: a valid album UPC code string
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: array of TidalAlbum
    ///
    public func getAlbums(withUPC albumUPC: String,
                          countryCode: String = "US") async throws -> [TidalAlbum] {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid UPC...
        let trimmedUPC = albumUPC.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUPC.isEmpty else {
            throw TidalAPIError.invalidInput(albumUPC)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.getAlbums(withUPC: trimmedUPC,
                                                   accessToken: accessToken,
                                                   countryCode: countryCode)
        let albumsResource: TidalAlbumsResource = try await apiManager.sendRequest(with: endpoint)

        guard !albumsResource.data.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return albumsResource.data
    }

    /// Searches the TIDAL catalog for albums with a known title from artists with a known name
    ///
    /// - Parameters:
    ///   - withTitle: a full album title
    ///   - artistName: an artist name or portion of
    /// - Returns: array of TidalAlbum
    ///
    public func searchAlbums(withTitle albumTitle: String, artistName: String) async throws -> [TidalAlbum] {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid album title...
        let trimmedTitle = albumTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            throw TidalAPIError.invalidInput(albumTitle)
        }
        // Check for invalid artist name...
        let trimmedName = artistName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw TidalAPIError.invalidInput(artistName)
        }
        // Prepare query string...
        let rawQueryString = "\(trimmedTitle) - \(trimmedName)"
        guard let queryString = rawQueryString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw TidalAPIError.couldNotEscapeString(rawQueryString)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.search(withQuery: queryString,
                                                type: .albums,
                                                accessToken: accessToken)
        let searchResults: TidalAlbumSearchResults = try await apiManager.sendRequest(with: endpoint)

        guard let albums = searchResults.included,
              !albums.isEmpty else {
            throw TidalAPIError.noItemsFound
        }
        // now try search with album names matching exactly (don't strip parentheticals yet)
        let lcAlbumTitle = albumTitle.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let exactAlbums = albums.filter {
            guard let thisTitle = $0.attributes?.title else { return false }
            let lcThisAlbumTitle = thisTitle.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            return lcThisAlbumTitle == lcAlbumTitle
        }
        var matchingAlbums = exactAlbums
        if exactAlbums.isEmpty {
            // there were no exact results so try filtering again, ignoring parentheticals this time
            var titleWithNoParenthesis = albumTitle
            if let index = albumTitle.firstIndex(of: "(") {
                titleWithNoParenthesis = String(albumTitle.prefix(upTo: index))
            }
            var titleWithNoParentheticals = titleWithNoParenthesis
            if let index = titleWithNoParenthesis.firstIndex(of: "[") {
                titleWithNoParentheticals = String(titleWithNoParenthesis.prefix(upTo: index))
            }
            let lcTitleWithNoParentheticals = titleWithNoParentheticals.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            matchingAlbums = albums.filter {
                guard let thisTitle = $0.attributes?.title else { return false }
                var thisTitleWithNoParenthesis = thisTitle
                if let index = thisTitle.firstIndex(of: "(") {
                    thisTitleWithNoParenthesis = String(thisTitle.prefix(upTo: index))
                }
                var thisTitleWithNoParentheticals = thisTitleWithNoParenthesis
                if let index = thisTitleWithNoParenthesis.firstIndex(of: "[") {
                    thisTitleWithNoParentheticals = String(thisTitleWithNoParenthesis.prefix(upTo: index))
                }
                let lcThisAlbumTitle = thisTitleWithNoParentheticals.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                return lcThisAlbumTitle == lcTitleWithNoParentheticals
            }
        }
        guard !matchingAlbums.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return matchingAlbums
    }

    private func checkAuth() async throws -> Bool {
        guard accessToken == nil || tokenExpiration.timeIntervalSinceNow < 60 else { return true }

        try await authorize()

        return accessToken != nil
    }

    private func authorize() async throws {
        let endpoint = TidalAuthEndpoints.authToken(clientID: clientID,
                                                    clientSecret: clientSecret)
        let response: TidalAuthResponse = try await authManager.sendRequest(with: endpoint)

        guard response.tokenType.lowercased() == "bearer" else {
            throw TidalAuthError.unexpectedTokenType(response.tokenType)
        }

        accessToken = response.accessToken
        tokenExpiration = Date(timeIntervalSinceNow: TimeInterval(response.expiresIn))
    }
}
