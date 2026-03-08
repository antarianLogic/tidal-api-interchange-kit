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
        public static let badBunny = JSONDecoder().decode(TidalSearchResults.self, fromResource: "JSON/ArtistSearchBadBunny", inBundle: Bundle.module)!
        public static let subbacultcha = JSONDecoder().decode(TidalSearchResults.self, fromResource: "JSON/TrackSearchSubbacultcha", inBundle: Bundle.module)!
        public static let shoegaze = JSONDecoder().decode(TidalSearchResults.self, fromResource: "JSON/PlaylistSearchShoegaze", inBundle: Bundle.module)!
        public static let purple = JSONDecoder().decode(TidalSearchResults.self, fromResource: "JSON/TopHitSearchPurple", inBundle: Bundle.module)!
        public static let thriller = JSONDecoder().decode(TidalSearchResults.self, fromResource: "JSON/VideoSearchThriller", inBundle: Bundle.module)!
    }
}
