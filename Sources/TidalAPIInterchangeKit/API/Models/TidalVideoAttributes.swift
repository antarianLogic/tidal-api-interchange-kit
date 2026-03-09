//
//  TidalVideoAttributes.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/7/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Videos_Attributes`

public struct TidalVideoAttributes: Codable, Equatable, Hashable, Sendable {

    public let copyright: TidalCopyright?

    public let iso8601Duration: String

    public let isExplicit: Bool

    public let externalLinks: [TidalExternalLink]?

    public let isrc: String

    public let popularity: Double

    public let iso8601ReleaseDate: String?

    public let title: String

    public let version: String?

    public init(copyright: TidalCopyright? = nil,
                iso8601Duration: String,
                isExplicit: Bool,
                externalLinks: [TidalExternalLink]? = nil,
                isrc: String,
                popularity: Double,
                iso8601ReleaseDate: String? = nil,
                title: String,
                version: String? = nil) {
        self.copyright = copyright
        self.iso8601Duration = iso8601Duration
        self.isExplicit = isExplicit
        self.externalLinks = externalLinks
        self.isrc = isrc
        self.popularity = popularity
        self.iso8601ReleaseDate = iso8601ReleaseDate
        self.title = title
        self.version = version
    }

    enum CodingKeys: String, CodingKey {
        case copyright
        case iso8601Duration = "duration"
        case isExplicit = "explicit"
        case externalLinks
        case isrc
        case popularity
        case iso8601ReleaseDate = "releaseDate"
        case title
        case version
    }
}

public extension TidalVideoAttributes {

    var releaseDate: Date? {
        guard let iso8601ReleaseDate else { return nil }

        return try? Date.ISO8601FormatStyle.dateOnlyStyle.parse(iso8601ReleaseDate)
    }

    // TODO: add getter to convert iso8601Duration to TimeInterval
}
