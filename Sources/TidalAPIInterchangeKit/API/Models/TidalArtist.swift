//
//  TidalArtist.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artists_Resource_Object`

public struct TidalArtist: Codable, Equatable, Hashable, Sendable {

    public let attributes: TidalArtistAttributes?

    public let id: String

    // Not including the relationships property for now
    // public let relationships: ...

    public let type: String

    public init(attributes: TidalArtistAttributes? = nil,
                id: String,
                type: String) {
        self.attributes = attributes
        self.id = id
        self.type = type
    }
}
