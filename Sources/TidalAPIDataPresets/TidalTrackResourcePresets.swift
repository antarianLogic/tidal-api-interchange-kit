//
//  TidalTrackResourcePresets.swift
//  TidalAPIDataPresets
//
//  Created by Carl Sheppard on 2/16/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import TidalAPIInterchangeKit

public extension TidalTrackResource {
    enum Presets {
        public static let subbacultcha = JSONDecoder().decode(TidalTrackResource.self, fromResource: "JSON/TrackSubbacultcha", inBundle: Bundle.module)!
    }
}
