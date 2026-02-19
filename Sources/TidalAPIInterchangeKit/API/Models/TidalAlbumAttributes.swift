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

    public let barcodeId: String

    public let copyright: TidalCopyright?

    public let duration: String

    public let explicit: Bool

    public let externalLinks: [TidalExternalLink]?

    public let mediaTags: [String]

    public let numberOfItems: Int32

    public let numberOfVolumes: Int32

    public let popularity: Double

    public let releaseDate: String?

    public let version: String?

    public init(title: String,
                accessType: String? = nil,
                albumType: String,
                barcodeId: String,
                copyright: TidalCopyright? = nil,
                duration: String,
                explicit: Bool,
                externalLinks: [TidalExternalLink]? = nil,
                mediaTags: [String],
                numberOfItems: Int32,
                numberOfVolumes: Int32,
                popularity: Double,
                releaseDate: String? = nil,
                version: String? = nil) {
        self.title = title
        self.accessType = accessType
        self.albumType = albumType
        self.barcodeId = barcodeId
        self.copyright = copyright
        self.duration = duration
        self.explicit = explicit
        self.externalLinks = externalLinks
        self.mediaTags = mediaTags
        self.numberOfItems = numberOfItems
        self.numberOfVolumes = numberOfVolumes
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.version = version
    }
}
