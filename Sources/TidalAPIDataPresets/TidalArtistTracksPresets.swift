//
//  TidalArtistTracksPresets.swift
//  TidalAPIDataPresets
//
//  Created by Carl Sheppard on 2/16/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import TidalAPIInterchangeKit

public extension TidalArtistTracks {
    enum Presets {
        public static let pixies = JSONDecoder().decode(TidalArtistTracks.self, fromResource: "JSON/TracksPixies", inBundle: Bundle.module)!
    }
}
