//
//  TidalAlbumSearchResults.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/17/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/SearchResults_Single_Resource_Data_Document`

public struct TidalAlbumSearchResults: Codable, Equatable, Hashable, Sendable {

    // Not including the data property for now.
    // public let data: TidalAlbum

    public let included: [TidalAlbum]?

    // Not including the links property for now. They are either already known or can be generated from known data.
    // public let links: ...

    public init(included: [TidalAlbum]? = nil) {
        self.included = included
    }
}
