//
//  TidalArtwork.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/6/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artworks_Resource_Object`

public struct TidalArtwork: Codable, Equatable, Hashable, Sendable {

    public let attributes: TidalArtworkAttributes?

    public let id: String

    // Not including the relationships property for now as it is quite nested and I'm not sure we actually need it.
    // public let relationships: ...

    public let type: String

    public init(attributes: TidalArtworkAttributes? = nil,
                id: String,
                type: String) {
        self.attributes = attributes
        self.id = id
        self.type = type
    }
}
