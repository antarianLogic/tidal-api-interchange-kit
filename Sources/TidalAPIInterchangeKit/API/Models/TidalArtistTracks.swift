//
//  TidalArtistTracks.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artists_Multi_Relationship_Data_Document`

public struct TidalArtistTracks: Codable, Equatable, Hashable, Sendable {

    public let data: [TidalResource]?

    public let included: [TidalTrack]?

    // Not including the links property for now. They are either already known or can be generated from known data.
    // public let links: ...

    public init(data: [TidalResource]? = nil,
                included: [TidalTrack]? = nil) {
        self.data = data
        self.included = included
    }
}
