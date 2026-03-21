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
        // Note: The tracks in the JSON (and returned here) seem to be in the same order as on the album.
        return included.compactMap {
            if case let .tracks(tidalTracks) = $0 {
                return tidalTracks
            } else {
                return nil
            }
        }
    }

    var imageArtwork: [TidalArtwork] {
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

    var smallestImage: TidalArtworkFile? {
        guard let attributes = imageArtwork.first?.attributes else { return nil }

        return attributes.files.min { lhsFile, rhsFile in
            (lhsFile.meta?.width ?? 0) * (lhsFile.meta?.height ?? 0) < (rhsFile.meta?.width ?? 0) * (rhsFile.meta?.height ?? 0)
        }
    }

    var largestImage: TidalArtworkFile? {
        guard let attributes = imageArtwork.first?.attributes else { return nil }

        return attributes.files.max { lhsFile, rhsFile in
            (lhsFile.meta?.width ?? 0) * (lhsFile.meta?.height ?? 0) < (rhsFile.meta?.width ?? 0) * (rhsFile.meta?.height ?? 0)
        }
    }

    func smallestImageWithSizeAtLeast(width: Int, height: Int) -> TidalArtworkFile? {
        guard let attributes = imageArtwork.first?.attributes else { return nil }

        return attributes.files.reduce(nil) {
            guard let fileWidth = $1.meta?.width,
                  let fileHeight = $1.meta?.height,
                  fileWidth >= width,
                  fileHeight >= height else { return $0 }

            guard let accumulatedFile = $0,
                  let accumulatedWidth = accumulatedFile.meta?.width,
                  let accumulatedHeight = accumulatedFile.meta?.height else { return $1 }

            if fileWidth < accumulatedWidth,
               fileHeight < accumulatedHeight {
                return $1
            } else {
                return accumulatedFile
            }
        }
    }

    var videoArtwork: [TidalArtwork] {
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
