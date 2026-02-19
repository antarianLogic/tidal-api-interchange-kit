//
//  TidalAuthResponsePresets.swift
//  TidalAPIDataPresets
//
//  Created by Carl Sheppard on 2/16/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import TidalAPIInterchangeKit

public extension TidalAuthResponse {
    enum Presets {
        public static let validToken = TidalAuthResponse(accessToken: "MOCK_ACCESS_TOKEN", expiresIn: 60, tokenType: "bearer")
        public static let invalidToken = TidalAuthResponse(accessToken: "MOCK_ACCESS_TOKEN", expiresIn: 60, tokenType: "invalid")
    }
}
