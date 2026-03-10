//
//  TidalAlbumItemResource.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/10/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Albums_Items_Resource_Identifier`

public struct TidalAlbumItemResource: Codable, Equatable, Hashable, Sendable {

    public let id: String

    public let meta: TidalAlbumItemMeta?

    public let type: String

    public init(id: String,
                meta: TidalAlbumItemMeta? = nil,
                type: String) {
        self.id = id
        self.meta = meta
        self.type = type
    }
}
