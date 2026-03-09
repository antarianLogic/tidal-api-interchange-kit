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

    public let iso8601CreatedAt: String?

    public let iso8601Duration: String

    public let isExplicit: Bool

    public let externalLinks: [TidalExternalLink]?

    public let isrc: String

    public let key: String?

    public let keyScale: String?

    public let mediaTags: [String]

    public let popularity: Double

    public let isSpotlighted: Bool?

    public let toneTags: [String]?

    public let version: String?

    public init(title: String,
                accessType: String? = nil,
                bpm: Float? = nil,
                copyright: TidalCopyright? = nil,
                iso8601CreatedAt: String? = nil,
                iso8601Duration: String,
                isExplicit: Bool,
                externalLinks: [TidalExternalLink]? = nil,
                isrc: String,
                key: String? = nil,
                keyScale: String? = nil,
                mediaTags: [String],
                popularity: Double,
                isSpotlighted: Bool? = nil,
                toneTags: [String]?,
                version: String? = nil) {
        self.title = title
        self.accessType = accessType
        self.bpm = bpm
        self.copyright = copyright
        self.iso8601CreatedAt = iso8601CreatedAt
        self.iso8601Duration = iso8601Duration
        self.isExplicit = isExplicit
        self.externalLinks = externalLinks
        self.isrc = isrc
        self.key = key
        self.keyScale = keyScale
        self.mediaTags = mediaTags
        self.popularity = popularity
        self.isSpotlighted = isSpotlighted
        self.toneTags = toneTags
        self.version = version
    }

    enum CodingKeys: String, CodingKey {
        case title
        case accessType
        case bpm
        case copyright
        case iso8601CreatedAt = "createdAt"
        case iso8601Duration = "duration"
        case isExplicit = "explicit"
        case externalLinks
        case isrc
        case key
        case keyScale
        case mediaTags
        case popularity
        case isSpotlighted = "spotlighted"
        case toneTags
        case version
    }
}

public extension TidalTrackAttributes {

    var creationDate: Date? {
        guard let iso8601CreatedAt else { return nil }

        return try? Date.ISO8601FormatStyle.dateTimeStyle.parse(iso8601CreatedAt)
    }

    // TODO: add getter to convert iso8601Duration to TimeInterval
}
