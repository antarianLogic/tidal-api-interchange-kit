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

    public let isBounded: Bool

    public let iso8601CreatedAt: String

    public let description: String?

    public let iso8601Duration: String?

    public let externalLinks: [TidalExternalLink]

    public let iso8601LastModifiedAt: String

    public let name: String

    public let numberOfFollowers: Int32

    public let numberOfItems: Int32?

    public let playlistType: String

    public init(accessType: String,
                isBounded: Bool,
                iso8601CreatedAt: String,
                description: String? = nil,
                iso8601Duration: String? = nil,
                externalLinks: [TidalExternalLink],
                iso8601LastModifiedAt: String,
                name: String,
                numberOfFollowers: Int32,
                numberOfItems: Int32? = nil,
                playlistType: String) {
        self.accessType = accessType
        self.isBounded = isBounded
        self.iso8601CreatedAt = iso8601CreatedAt
        self.description = description
        self.iso8601Duration = iso8601Duration
        self.externalLinks = externalLinks
        self.iso8601LastModifiedAt = iso8601LastModifiedAt
        self.name = name
        self.numberOfFollowers = numberOfFollowers
        self.numberOfItems = numberOfItems
        self.playlistType = playlistType
    }

    enum CodingKeys: String, CodingKey {
        case accessType
        case isBounded = "bounded"
        case iso8601CreatedAt = "createdAt"
        case description
        case iso8601Duration = "duration"
        case externalLinks
        case iso8601LastModifiedAt = "lastModifiedAt"
        case name
        case numberOfFollowers
        case numberOfItems
        case playlistType
    }
}

public extension TidalPlaylistAttributes {

    var creationDate: Date? { try? Date.ISO8601FormatStyle.dateTimeStyle.parse(iso8601CreatedAt) }

    var modificationDate: Date? { try? Date.ISO8601FormatStyle.dateTimeStyle.parse(iso8601LastModifiedAt) }

    // TODO: add getter to convert iso8601Duration to TimeInterval
}
