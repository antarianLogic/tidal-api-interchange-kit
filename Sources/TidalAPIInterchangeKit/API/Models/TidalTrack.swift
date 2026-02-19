//
//  TidalTrack.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Tracks_Resource_Object`

public struct TidalTrack: Codable, Equatable, Hashable, Sendable {

    public let attributes: TidalTrackAttributes?

    public let id: String

    // Not including the relationships property for now as it is quite nested and I'm not sure we actually need it.
    // public let relationships: ...

    public let type: String

    public init(attributes: TidalTrackAttributes? = nil,
                id: String,
                type: String) {
        self.attributes = attributes
        self.id = id
        self.type = type
    }
}
