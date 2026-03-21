//
//  TidalArtwork.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 3/6/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Artworks_Resource_Object`

public struct TidalArtwork: Codable, Equatable, Hashable, Sendable {

    public let attributes: TidalArtworkAttributes?

    public let id: String

    // Not including the relationships property for now as it is quite nested and I'm not sure we actually need it.
    // public let relationships: ...

    public let type: String

    public init(attributes: TidalArtworkAttributes? = nil,
                id: String,
                type: String) {
        self.attributes = attributes
        self.id = id
        self.type = type
    }
}

public extension TidalArtwork {

    var smallestImage: TidalArtworkFile? {
        guard let attributes else { return nil }

        return attributes.files.min { lhsFile, rhsFile in
            (lhsFile.meta?.width ?? 0) * (lhsFile.meta?.height ?? 0) < (rhsFile.meta?.width ?? 0) * (rhsFile.meta?.height ?? 0)
        }
    }

    var largestImage: TidalArtworkFile? {
        guard let attributes else { return nil }

        return attributes.files.max { lhsFile, rhsFile in
            (lhsFile.meta?.width ?? 0) * (lhsFile.meta?.height ?? 0) < (rhsFile.meta?.width ?? 0) * (rhsFile.meta?.height ?? 0)
        }
    }

    func smallestImageWithSizeAtLeast(width: Int, height: Int) -> TidalArtworkFile? {
        guard let attributes else { return nil }

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
}
