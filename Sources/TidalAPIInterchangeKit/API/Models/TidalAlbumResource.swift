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

    var videoArtwork: [TidalArtwork] {
        guard let included else { return [] }

        return included.videoArtwork
    }

    func trackAt(volumeNumber: Int, trackNumber: Int) -> TidalTrack? {
        guard let included,
              let trackData = data.relationships?.items.data else { return nil }

        // see if we can find a track ID in the data that has a matching volume and track number
        let matchingTrackData = trackData.first {
            guard let meta = $0.meta else { return false }
            return meta.volumeNumber == volumeNumber && meta.trackNumber == trackNumber
        }
        guard let matchingTrackID = matchingTrackData?.id else { return nil }

        // now find the track included type object with that ID
        let trackIncludedType = included.first {
            guard case let .tracks(tidalTracks) = $0 else { return false }
            return tidalTracks.id == matchingTrackID
        }
        // unwrap the actual track object from the associated data
        guard case let .tracks(tidalTrack) = trackIncludedType else { return nil }

        return tidalTrack
    }
}
