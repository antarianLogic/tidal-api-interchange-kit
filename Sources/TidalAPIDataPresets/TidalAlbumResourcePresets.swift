//
//  TidalAlbumResourcePresets.swift
//  TidalAPIDataPresets
//
//  Created by Carl Sheppard on 2/16/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import TidalAPIInterchangeKit

public extension TidalAlbumResource {
    enum Presets {
        public static let nevermind = JSONDecoder().decode(TidalAlbumResource.self, fromResource: "JSON/AlbumNevermind", inBundle: Bundle.module)!
    }
}
