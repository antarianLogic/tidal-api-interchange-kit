//
//  TidalArtistAttributes.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/4/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artists_Attributes`

public struct TidalArtistAttributes: Codable, Equatable, Hashable, Sendable {

    public let name: String

    public let contributionsEnabled: Bool?

    public let contributionsSalesPitch: String?

    public let externalLinks: [TidalExternalLink]?

    public let handle: String?

    public let ownerType: String?

    public let popularity: Double

    public let spotlighted: Bool?

    public init(name: String,
                contributionsEnabled: Bool? = nil,
                contributionsSalesPitch: String? = nil,
                externalLinks: [TidalExternalLink]? = nil,
                handle: String? = nil,
                ownerType: String? = nil,
                popularity: Double,
                spotlighted: Bool? = nil) {
        self.name = name
        self.contributionsEnabled = contributionsEnabled
        self.contributionsSalesPitch = contributionsSalesPitch
        self.externalLinks = externalLinks
        self.handle = handle
        self.ownerType = ownerType
        self.popularity = popularity
        self.spotlighted = spotlighted
    }
}
