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
