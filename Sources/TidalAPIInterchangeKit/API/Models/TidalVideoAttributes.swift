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

    public let duration: String

    public let explicit: Bool

    public let externalLinks: [TidalExternalLink]?

    public let isrc: String

    public let popularity: Double

    // Release date (ISO-8601)
    public let releaseDate: String?

    public let title: String

    public let version: String?

    public init(copyright: TidalCopyright? = nil,
                duration: String,
                explicit: Bool,
                externalLinks: [TidalExternalLink]? = nil,
                isrc: String,
                popularity: Double,
                releaseDate: String? = nil,
                title: String,
                version: String? = nil) {
        self.copyright = copyright
        self.duration = duration
        self.explicit = explicit
        self.externalLinks = externalLinks
        self.isrc = isrc
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.title = title
        self.version = version
    }
}
