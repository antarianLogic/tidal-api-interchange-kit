//
//  TidalCopyright.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/15/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation

// For the schema this type was based on, see: `https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json#/components/schemas/Copyright`

public struct TidalCopyright: Codable, Equatable, Hashable, Sendable {

    public let text: String

    public init(text: String) {
        self.text = text
    }
}
