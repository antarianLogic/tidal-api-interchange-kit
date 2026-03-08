//
//  TidalPlaylistAttributes.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/7/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Playlists_Attributes`

public struct TidalPlaylistAttributes: Codable, Equatable, Hashable, Sendable {

    public let accessType: String

    public let bounded: Bool

    // Datetime of playlist creation (ISO 8601)
    public let createdAt: String

    public let description: String?

    // Duration of playlist (ISO 8601)
    public let duration: String?

    public let externalLinks: [TidalExternalLink]

    /// Datetime of last modification of the playlist (ISO 8601)
    public let lastModifiedAt: String

    public let name: String

    public let numberOfFollowers: Int32

    public let numberOfItems: Int32?

    public let playlistType: String

    public init(accessType: String,
                bounded: Bool,
                createdAt: String,
                description: String? = nil,
                duration: String? = nil,
                externalLinks: [TidalExternalLink],
                lastModifiedAt: String,
                name: String,
                numberOfFollowers: Int32,
                numberOfItems: Int32? = nil,
                playlistType: String) {
        self.accessType = accessType
        self.bounded = bounded
        self.createdAt = createdAt
        self.description = description
        self.duration = duration
        self.externalLinks = externalLinks
        self.lastModifiedAt = lastModifiedAt
        self.name = name
        self.numberOfFollowers = numberOfFollowers
        self.numberOfItems = numberOfItems
        self.playlistType = playlistType
    }
}
