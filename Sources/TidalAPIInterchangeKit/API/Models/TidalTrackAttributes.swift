//
//  TidalTrackAttributes.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Tracks_Attributes`

public struct TidalTrackAttributes: Codable, Equatable, Hashable, Sendable {

    public let title: String

    public let accessType: String?

    public let bpm: Float?

    public let copyright: TidalCopyright?

    public let createdAt: String?

    public let duration: String

    public let explicit: Bool

    public let externalLinks: [TidalExternalLink]?

    public let isrc: String

    public let key: String?

    public let keyScale: String?

    public let mediaTags: [String]

    public let popularity: Double

    public let spotlighted: Bool?

    public let toneTags: [String]?

    public let version: String?

    public init(title: String,
                accessType: String? = nil,
                bpm: Float? = nil,
                copyright: TidalCopyright? = nil,
                createdAt: String? = nil,
                duration: String,
                explicit: Bool,
                externalLinks: [TidalExternalLink]? = nil,
                isrc: String,
                key: String? = nil,
                keyScale: String? = nil,
                mediaTags: [String],
                popularity: Double,
                spotlighted: Bool? = nil,
                toneTags: [String]?,
                version: String? = nil) {
        self.title = title
        self.accessType = accessType
        self.bpm = bpm
        self.copyright = copyright
        self.createdAt = createdAt
        self.duration = duration
        self.explicit = explicit
        self.externalLinks = externalLinks
        self.isrc = isrc
        self.key = key
        self.keyScale = keyScale
        self.mediaTags = mediaTags
        self.popularity = popularity
        self.spotlighted = spotlighted
        self.toneTags = toneTags
        self.version = version
    }
}
