//
//  TidalIncludedType.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/6/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Included`

public enum TidalIncludedType: Codable, Equatable, Hashable, Sendable {

    case albums(TidalAlbum)
    case artists(TidalArtist)
    case artworks(TidalArtwork)
    case playlists(TidalPlaylist)
    case tracks(TidalTrack)
    case videos(TidalVideo)

    enum CodingKeys: CodingKey {
        case type
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "albums":
            self = .albums(try TidalAlbum(from: decoder))
        case "artists":
            self = .artists(try TidalArtist(from: decoder))
        case "artworks":
            self = .artworks(try TidalArtwork(from: decoder))
        case "playlists":
            self = .playlists(try TidalPlaylist(from: decoder))
        case "tracks":
            self = .tracks(try TidalTrack(from: decoder))
        case "videos":
            self = .videos(try TidalVideo(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "expected `albums`, 'artworks', or 'tracks', got \(type) instead")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .albums(value):
            try value.encode(to: encoder)
        case let .artists(value):
            try value.encode(to: encoder)
        case let .artworks(value):
            try value.encode(to: encoder)
        case let .playlists(value):
            try value.encode(to: encoder)
        case let .tracks(value):
            try value.encode(to: encoder)
        case let .videos(value):
            try value.encode(to: encoder)
        }
    }
}

public extension [TidalIncludedType] {

    var albums: [TidalAlbum] {
        return compactMap {
            if case let .albums(tidalAlbum) = $0 {
                return tidalAlbum
            } else {
                return nil
            }
        }
    }

    var artists: [TidalArtist] {
        return compactMap {
            if case let .artists(tidalArtist) = $0 {
                return tidalArtist
            } else {
                return nil
            }
        }
    }

    var imageArtwork: [TidalArtwork] {
        return compactMap {
            if case let .artworks(tidalArtwork) = $0 {
                guard tidalArtwork.attributes?.mediaType == "IMAGE" else { return nil }
                return tidalArtwork
            } else {
                return nil
            }
        }
    }

    var videoArtwork: [TidalArtwork] {
        return compactMap {
            if case let .artworks(tidalArtwork) = $0 {
                guard tidalArtwork.attributes?.mediaType == "VIDEO" else { return nil }
                return tidalArtwork
            } else {
                return nil
            }
        }
    }

    var playlists: [TidalPlaylist] {
        return compactMap {
            if case let .playlists(tidalPlaylist) = $0 {
                return tidalPlaylist
            } else {
                return nil
            }
        }
    }

    var tracks: [TidalTrack] {
        // Note: The tracks in the JSON (and returned here) seem to be in the same order as on the album.
        return compactMap {
            if case let .tracks(tidalTracks) = $0 {
                return tidalTracks
            } else {
                return nil
            }
        }
    }

    var videos: [TidalVideo] {
        return compactMap {
            if case let .videos(tidalVideo) = $0 {
                return tidalVideo
            } else {
                return nil
            }
        }
    }
}
