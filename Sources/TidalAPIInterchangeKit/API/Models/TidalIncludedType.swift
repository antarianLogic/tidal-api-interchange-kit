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

    case artworks(TidalArtwork)
    case tracks(TidalTrack)

    enum CodingKeys: CodingKey {
        case type
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "artworks":
            self = .artworks(try TidalArtwork(from: decoder))
        case "tracks":
            self = .tracks(try TidalTrack(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "expected 'artworks' or 'tracks', got \(type) instead")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .artworks(value):
            try value.encode(to: encoder)
        case let .tracks(value):
            try value.encode(to: encoder)
        }
    }
}
