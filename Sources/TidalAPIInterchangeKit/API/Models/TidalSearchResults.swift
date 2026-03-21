//
//  TidalSearchResults.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/17/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/SearchResults_Single_Resource_Data_Document`

public struct TidalSearchResults: Codable, Equatable, Hashable, Sendable {

    // Not including the data property for now.
    // public let data: ...

    public let included: [TidalIncludedType]?

    // Not including the links property for now. They are either already known or can be generated from known data.
    // public let links: ...

    public init(included: [TidalIncludedType]? = nil) {
        self.included = included
    }
}

public extension TidalSearchResults {

    var albums: [TidalAlbum] {
        guard let included else { return [] }

        return included.albums
    }

    var artists: [TidalArtist] {
        guard let included else { return [] }

        return included.artists
    }

    var playlists: [TidalPlaylist] {
        guard let included else { return [] }

        return included.playlists
    }

    var tracks: [TidalTrack] {
        guard let included else { return [] }

        return included.tracks
    }

    var videos: [TidalVideo] {
        guard let included else { return [] }

        return included.videos
    }
}
