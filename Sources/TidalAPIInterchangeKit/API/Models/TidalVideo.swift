//
//  TidalVideo.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/7/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Videos_Resource_Object`

public struct TidalVideo: Codable, Equatable, Hashable, Sendable {

    public let attributes: TidalVideoAttributes?

    public let id: String

    // Not including the relationships property for now as it is quite nested and I'm not sure we actually need it.
    // public let relationships: ...

    public let type: String

    public init(attributes: TidalVideoAttributes? = nil,
                id: String,
                type: String) {
        self.attributes = attributes
        self.id = id
        self.type = type
    }
}
