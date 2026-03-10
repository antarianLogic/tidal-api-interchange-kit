//
//  TidalAlbumRelationships.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/10/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Albums_Relationships`

public struct TidalAlbumRelationships: Codable, Equatable, Hashable, Sendable {

    // Only including the items property for now. It's the only one we care about as it contains the track volume and position info.

    // public let artists: ...

    // public let coverArt: ...

    // public let genres: ...

    public let items: TidalAlbumItemRelationship

    // public let owners: ...

    // public let priceConfig: ...

    // public let providers: ...

    // public let replacement: ...

    // public let similarAlbums: ...

    // public let suggestedCoverArts: ...

    // public let usageRules: ...

    public init(items: TidalAlbumItemRelationship) {
        self.items = items
    }
}
