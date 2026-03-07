//
//  TidalArtworkVisualMetadata.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/6/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artwork_VisualMetadata`

public struct TidalArtworkVisualMetadata: Codable, Equatable, Hashable, Sendable {

    public let blurHash: String?

    public let selectedPaletteColor: String?

    public let status: String?

    public init(blurHash: String? = nil,
                selectedPaletteColor: String? = nil,
                status: String? = nil) {
        self.blurHash = blurHash
        self.selectedPaletteColor = selectedPaletteColor
        self.status = status
    }
}
