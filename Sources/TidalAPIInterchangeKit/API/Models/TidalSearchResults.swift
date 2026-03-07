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

        return included.compactMap {
            if case let .albums(tidalAlbum) = $0 {
                return tidalAlbum
            } else {
                return nil
            }
        }
    }

    var artists: [TidalArtist] {
        guard let included else { return [] }

        return included.compactMap {
            if case let .artists(tidalArtist) = $0 {
                return tidalArtist
            } else {
                return nil
            }
        }
    }

    var playlists: [TidalPlaylist] {
        guard let included else { return [] }

        return included.compactMap {
            if case let .playlists(tidalPlaylist) = $0 {
                return tidalPlaylist
            } else {
                return nil
            }
        }
    }

    var tracks: [TidalTrack] {
        guard let included else { return [] }

        return included.compactMap {
            if case let .tracks(tidalTracks) = $0 {
                return tidalTracks
            } else {
                return nil
            }
        }
    }

    var videos: [TidalVideo] {
        guard let included else { return [] }

        return included.compactMap {
            if case let .videos(tidalVideo) = $0 {
                return tidalVideo
            } else {
                return nil
            }
        }
    }
}
