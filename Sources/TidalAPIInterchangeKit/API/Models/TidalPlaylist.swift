//
//  TidalPlaylist.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/7/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Playlists_Resource_Object`

public struct TidalPlaylist: Codable, Equatable, Hashable, Sendable {

    public let attributes: TidalPlaylistAttributes?

    public let id: String

    // Not including the relationships property for now
    // public let relationships: ...

    public let type: String

    public init(attributes: TidalPlaylistAttributes? = nil,
                id: String,
                type: String) {
        self.attributes = attributes
        self.id = id
        self.type = type
    }
}
