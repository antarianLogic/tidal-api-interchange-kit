//
//  TidalAlbumItemRelationship.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/10/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Albums_Items_Multi_Relationship_Data_Document`

public struct TidalAlbumItemRelationship: Codable, Equatable, Hashable, Sendable {

    public let data: [TidalAlbumItemResource]?

    // Not including the included property for now. Not seeing it in real response JSON.
    // public let included: TidalIncludedType?

    // Not including the links property for now. They are either already known or can be generated from known data.
    // public let links: ...

    public init(data: [TidalAlbumItemResource]? = nil) {
        self.data = data
    }
}
