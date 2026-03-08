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
                                   countryCode: String = "US") async throws -> TidalArtistTracks {
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
        let endpoint = TidalAPIEndpoints.artistTracks(withID: trimmedID,
                                                      accessToken: accessToken,
                                                      countryCode: countryCode)
        let artistTracks: TidalArtistTracks = try await apiManager.sendRequest(with: endpoint)

        guard !artistTracks.tracks.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return artistTracks
    }

    /// Returns album details including tracks and artwork for a known TIDAL album ID
    ///
    /// - Parameters:
    ///   - withID: TIDAL album ID string
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: TidalAlbumResource
    ///
    public func getAlbum(withID albumID: String,
                         countryCode: String = "US") async throws -> TidalAlbumResource {
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

        return albumRes
    }

    /// Retrieves the TIDAL catalog for albums with known UPC codes
    ///
    /// - Parameters:
    ///   - withUPCs: array of valid album UPC code strings
    ///   - countryCode: Country code string. Defaults to "US".
    /// - Returns: array of TidalAlbum
    ///
    public func getAlbums(withUPCs albumUPCs: [String],
                          countryCode: String = "US") async throws -> [TidalAlbum] {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid UPCs...
        let trimmedUPCs = albumUPCs
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        guard !trimmedUPCs.isEmpty else {
            throw TidalAPIError.invalidInput(albumUPCs.joined(separator: ","))
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.getAlbums(withUPCs: trimmedUPCs,
                                                   accessToken: accessToken,
                                                   countryCode: countryCode)
        let albumsResource: TidalAlbumsResource = try await apiManager.sendRequest(with: endpoint)

        guard !albumsResource.data.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return albumsResource.data
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
        let searchResults: TidalSearchResults = try await apiManager.sendRequest(with: endpoint)

        guard !searchResults.albums.isEmpty else {
            throw TidalAPIError.noItemsFound
        }
        // now try search with album names matching exactly (don't strip parentheticals yet)
        let lcAlbumTitle = albumTitle.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let exactAlbums = searchResults.albums.filter {
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
            matchingAlbums = searchResults.albums.filter {
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

    /// Searches the TIDAL catalog for artists with a known name
    ///
    /// - Parameters:
    ///   - withName: an artist name or portion of
    /// - Returns: array of TidalArtist
    ///
    public func searchArtists(withName name: String) async throws -> [TidalArtist] {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid artist name...
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw TidalAPIError.invalidInput(name)
        }
        // Prepare query string...
        guard let queryString = trimmedName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw TidalAPIError.couldNotEscapeString(trimmedName)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.search(withQuery: queryString,
                                                type: .artists,
                                                accessToken: accessToken)
        let searchResults: TidalSearchResults = try await apiManager.sendRequest(with: endpoint)
        // now filter out artist names that don't contain our original string
        let filteredArtists = searchResults.artists.filter {
            guard let thisName = $0.attributes?.name else { return false }

//          return thisName.localizedCaseInsensitiveContains(trimmedName)
            return thisName.range(of: trimmedName, options: .caseInsensitive) != nil
        }

        guard !filteredArtists.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return filteredArtists
    }

    /// Searches the TIDAL catalog for playlists with a known name
    ///
    /// - Parameters:
    ///   - withName: an playlists name or portion of
    /// - Returns: array of TidalTrack
    ///
    public func searchPlaylists(withName name: String) async throws -> [TidalPlaylist] {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid playlist name...
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw TidalAPIError.invalidInput(name)
        }
        // Prepare query string...
        guard let queryString = trimmedName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw TidalAPIError.couldNotEscapeString(trimmedName)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.search(withQuery: queryString,
                                                type: .playlists,
                                                accessToken: accessToken)
        let searchResults: TidalSearchResults = try await apiManager.sendRequest(with: endpoint)
        // now filter out playlist names that don't contain our original string
        let filteredPlaylists = searchResults.playlists.filter {
            guard let thisName = $0.attributes?.name else { return false }

//          return thisName.localizedCaseInsensitiveContains(trimmedName)
            return thisName.range(of: trimmedName, options: .caseInsensitive) != nil
        }

        guard !filteredPlaylists.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return filteredPlaylists
    }

    /// Searches the TIDAL catalog for top search hits with arbitrary search text
    ///
    /// - Parameters:
    ///   - withText: arbitrary search text
    /// - Returns: TidalSearchResults
    ///
    public func searchTopHits(withText text: String) async throws -> TidalSearchResults {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid text...
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            throw TidalAPIError.invalidInput(text)
        }
        // Prepare query string...
        guard let queryString = trimmedText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw TidalAPIError.couldNotEscapeString(trimmedText)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.search(withQuery: queryString,
                                                type: .topHits,
                                                accessToken: accessToken)
        let searchResults: TidalSearchResults = try await apiManager.sendRequest(with: endpoint)

        guard let included = searchResults.included,
              !included.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return searchResults
    }

    /// Searches the TIDAL catalog for tracks with a known title
    ///
    /// - Parameters:
    ///   - withTitle: an track title or portion of
    /// - Returns: array of TidalTrack
    ///
    public func searchTracks(withTitle title: String) async throws -> [TidalTrack] {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid track name...
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            throw TidalAPIError.invalidInput(title)
        }
        // Prepare query string...
        guard let queryString = trimmedTitle.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw TidalAPIError.couldNotEscapeString(trimmedTitle)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.search(withQuery: queryString,
                                                type: .tracks,
                                                accessToken: accessToken)
        let searchResults: TidalSearchResults = try await apiManager.sendRequest(with: endpoint)
        // now filter out track titles that don't contain our original string
        let filteredTracks = searchResults.tracks.filter {
            guard let thisTitle = $0.attributes?.title else { return false }

//          return thisTitle.localizedCaseInsensitiveContains(trimmedTitle)
            return thisTitle.range(of: trimmedTitle, options: .caseInsensitive) != nil
        }

        guard !filteredTracks.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return filteredTracks
    }

    /// Searches the TIDAL catalog for videos with a known title
    ///
    /// - Parameters:
    ///   - withTitle: a video title or portion of
    /// - Returns: array of TidalVideo
    ///
    public func searchVideos(withTitle title: String) async throws -> [TidalVideo] {
        // First check TIDAL authorization...
        guard try await checkAuth(),
              let accessToken else {
            throw TidalAuthError.nilAccessToken
        }
        // Check for invalid video name...
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            throw TidalAPIError.invalidInput(title)
        }
        // Prepare query string...
        guard let queryString = trimmedTitle.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw TidalAPIError.couldNotEscapeString(trimmedTitle)
        }
        // Now make API request...
        let endpoint = TidalAPIEndpoints.search(withQuery: queryString,
                                                type: .videos,
                                                accessToken: accessToken)
        let searchResults: TidalSearchResults = try await apiManager.sendRequest(with: endpoint)
        // now filter out video titles that don't contain our original string
        let filteredVideos = searchResults.videos.filter {
            guard let thisTitle = $0.attributes?.title else { return false }

//          return thisTitle.localizedCaseInsensitiveContains(trimmedTitle)
            return thisTitle.range(of: trimmedTitle, options: .caseInsensitive) != nil
        }

        guard !filteredVideos.isEmpty else {
            throw TidalAPIError.noItemsFound
        }

        return filteredVideos
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
