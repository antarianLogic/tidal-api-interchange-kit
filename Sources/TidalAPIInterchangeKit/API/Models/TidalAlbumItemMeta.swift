//
//  TidalAlbumItemMeta.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/10/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Albums_Items_Resource_Identifier_Meta`

public struct TidalAlbumItemMeta: Codable, Equatable, Hashable, Sendable {

    public let trackNumber: Int32

    public let volumeNumber: Int32

    public init(trackNumber: Int32,
                volumeNumber: Int32) {
        self.trackNumber = trackNumber
        self.volumeNumber = volumeNumber
    }
}
