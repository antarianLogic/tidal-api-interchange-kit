//
//  TidalTrackResource.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/16/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Tracks_Single_Resource_Data_Document`

public struct TidalTrackResource: Codable, Equatable, Hashable, Sendable {

    public let data: TidalTrack

    // Not including the included property for now.
    // public let included: ...

    // Not including the links property for now. They are either already known or can be generated from known data.
    // public let links: ...

    public init(data: TidalTrack) {
        self.data = data
    }
}
