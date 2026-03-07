//
//  TidalArtworkFileMeta.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/6/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artwork_File_Meta`

public struct TidalArtworkFileMeta: Codable, Equatable, Hashable, Sendable {

    public let height: Int32

    public let width: Int32

    public init(height: Int32,
                width: Int32) {
        self.height = height
        self.width = width
    }
}
