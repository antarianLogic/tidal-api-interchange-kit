//
//  TidalArtworkFile.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/6/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artwork_File`

public struct TidalArtworkFile: Codable, Equatable, Hashable, Sendable {

    public let href: String

    public let meta: TidalArtworkFileMeta?

    public init(href: String,
                meta: TidalArtworkFileMeta? = nil) {
        self.href = href
        self.meta = meta
    }
}
