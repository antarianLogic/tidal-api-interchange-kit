//
//  TidalResource.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Resource_Identifier`

public struct TidalResource: Codable, Equatable, Hashable, Sendable {

    public let id: String

    public let type: String

    public init(id: String,
                type: String) {
        self.id = id
        self.type = type
    }
}
