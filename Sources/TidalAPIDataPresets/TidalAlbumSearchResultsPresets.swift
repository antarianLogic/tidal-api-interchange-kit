//
//  TidalAlbumSearchResultsPresets.swift
//  TidalAPIDataPresets
//
//  Created by Carl Sheppard on 2/17/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import TidalAPIInterchangeKit

public extension TidalSearchResults {
    enum Presets {
        public static let chromatica = JSONDecoder().decode(TidalSearchResults.self, fromResource: "JSON/AlbumSearchResultsChromaticaByLadyGaga", inBundle: Bundle.module)!
    }
}
