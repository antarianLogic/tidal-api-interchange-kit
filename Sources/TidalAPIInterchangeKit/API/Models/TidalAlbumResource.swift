//
//  TidalAlbumResource.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/16/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Albums_Single_Resource_Data_Document`

public struct TidalAlbumResource: Codable, Equatable, Hashable, Sendable {

    public let data: TidalAlbum

    public let included: [TidalIncludedType]?

    // Not including the links property for now. They are either already known or can be generated from known data.
    // public let links: ...

    public init(data: TidalAlbum,
                included: [TidalIncludedType]? = nil) {
        self.data = data
        self.included = included
    }
}

public extension TidalAlbumResource {

    var tracks: [TidalTrack] {
        guard let included else { return [] }
        // Note: The tracks in the JSON (and returned here) seem to be in the order as on the album, thankfully.
        // TODO: We could dig into the data.relationships.items.data to find the volume and track numbers if we wanted
        // to be sure. It would be nice to have that info at the track level too. We would need to decode the
        // relationships property in TidalAlbum first though and we aren't doing that currently.
        return included.compactMap {
            if case let .tracks(tidalTracks) = $0 {
                return tidalTracks
            } else {
                return nil
            }
        }
    }

    var images: [TidalArtwork] {
        guard let included else { return [] }

        return included.compactMap {
            if case let .artworks(tidalArtwork) = $0 {
                guard tidalArtwork.attributes?.mediaType == "IMAGE" else { return nil }
                return tidalArtwork
            } else {
                return nil
            }
        }
    }

    var videos: [TidalArtwork] {
        guard let included else { return [] }

        return included.compactMap {
            if case let .artworks(tidalArtwork) = $0 {
                guard tidalArtwork.attributes?.mediaType == "VIDEO" else { return nil }
                return tidalArtwork
            } else {
                return nil
            }
        }
    }
}
