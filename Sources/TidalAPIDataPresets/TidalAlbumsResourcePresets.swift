//
//  TidalAlbumsResourcePresets.swift
//  TidalAPIDataPresets
//
//  Created by Carl Sheppard on 2/19/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import TidalAPIInterchangeKit

public extension TidalAlbumsResource {
    enum Presets {
        public static let upc811408033985 = JSONDecoder().decode(TidalAlbumsResource.self, fromResource: "JSON/AlbumsWithUPC811408033985", inBundle: Bundle.module)!
    }
}
