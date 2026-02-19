//
//  TidalExternalLink.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/External_Link`

public struct TidalExternalLink: Codable, Equatable, Hashable, Sendable {

    public let href: String

    public let meta: Meta

    public init(href: String,
                meta: Meta) {
        self.href = href
        self.meta = meta
    }

    public struct Meta: Codable, Equatable, Hashable, Sendable {

        public let type: String

        public init(type: String) {
            self.type = type
        }
    }
}
