//
//  TidalArtworkAttributes.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/6/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artworks_Attributes`

public struct TidalArtworkAttributes: Codable, Equatable, Hashable, Sendable {

    public let files: [TidalArtworkFile]

    public let mediaType: String

    // Not including the sourceFile property for now
    // public let sourceFile: ...

    public let visualMetadata: TidalArtworkVisualMetadata?

    public init(files: [TidalArtworkFile],
                mediaType: String,
                visualMetadata: TidalArtworkVisualMetadata? = nil) {
        self.files = files
        self.mediaType = mediaType
        self.visualMetadata = visualMetadata
    }
}
