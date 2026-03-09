//
//  TidalAlbumAttributes.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/16/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Albums_Attributes`

public struct TidalAlbumAttributes: Codable, Equatable, Hashable, Sendable {

    public let title: String

    public let accessType: String?

    public let albumType: String

    public let barcodeID: String

    public let copyright: TidalCopyright?

    public let iso8601Duration: String

    public let isExplicit: Bool

    public let externalLinks: [TidalExternalLink]?

    public let mediaTags: [String]

    public let numberOfItems: Int32

    public let numberOfVolumes: Int32

    public let popularity: Double

    public let iso8601ReleaseDate: String?

    public let version: String?

    public init(title: String,
                accessType: String? = nil,
                albumType: String,
                barcodeID: String,
                copyright: TidalCopyright? = nil,
                iso8601Duration: String,
                isExplicit: Bool,
                externalLinks: [TidalExternalLink]? = nil,
                mediaTags: [String],
                numberOfItems: Int32,
                numberOfVolumes: Int32,
                popularity: Double,
                iso8601ReleaseDate: String? = nil,
                version: String? = nil) {
        self.title = title
        self.accessType = accessType
        self.albumType = albumType
        self.barcodeID = barcodeID
        self.copyright = copyright
        self.iso8601Duration = iso8601Duration
        self.isExplicit = isExplicit
        self.externalLinks = externalLinks
        self.mediaTags = mediaTags
        self.numberOfItems = numberOfItems
        self.numberOfVolumes = numberOfVolumes
        self.popularity = popularity
        self.iso8601ReleaseDate = iso8601ReleaseDate
        self.version = version
    }

    enum CodingKeys: String, CodingKey {
        case title
        case accessType
        case albumType
        case barcodeID = "barcodeId"
        case copyright
        case iso8601Duration = "duration"
        case isExplicit = "explicit"
        case externalLinks
        case mediaTags
        case numberOfItems
        case numberOfVolumes
        case popularity
        case iso8601ReleaseDate = "releaseDate"
        case version
    }
}

public extension TidalAlbumAttributes {

    var releaseDate: Date? {
        guard let iso8601ReleaseDate else { return nil }

        return try? Date.ISO8601FormatStyle.dateOnlyStyle.parse(iso8601ReleaseDate)
    }

    // TODO: add getter to convert iso8601Duration to TimeInterval
}
