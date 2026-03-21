//
//  TidalArtistTracks.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artists_Single_Resource_Data_Document`

public struct TidalArtistTracks: Codable, Equatable, Hashable, Sendable {

    public let data: TidalArtist

    public let included: [TidalIncludedType]?

    // Not including the links property for now. They are either already known or can be generated from known data.
    // public let links: ...

    public init(data: TidalArtist,
                included: [TidalIncludedType]? = nil) {
        self.data = data
        self.included = included
    }
}

public extension TidalArtistTracks {

    var tracks: [TidalTrack] {
        guard let included else { return [] }

        return included.tracks
    }

    var imageArtwork: [TidalArtwork] {
        guard let included else { return [] }

        return included.imageArtwork
    }

    var smallestImage: TidalArtworkFile? { imageArtwork.first?.smallestImage }

    var largestImage: TidalArtworkFile? { imageArtwork.first?.largestImage }

    func smallestImageWithSizeAtLeast(width: Int, height: Int) -> TidalArtworkFile? {
        return imageArtwork.first?.smallestImageWithSizeAtLeast(width: width, height: height)
    }
}
