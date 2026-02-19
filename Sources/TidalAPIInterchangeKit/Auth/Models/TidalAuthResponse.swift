//
//  TidalAuthResponse.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

public struct TidalAuthResponse: Codable, Equatable, Sendable {

    public let accessToken: String

    public let expiresIn: Int

    public let refreshToken: String?

    public let scope: String?

    public let tokenType: String

    public init(accessToken: String,
                expiresIn: Int,
                refreshToken: String? = nil,
                scope: String? = nil,
                tokenType: String) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.scope = scope
        self.tokenType = tokenType
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case tokenType = "token_type"
    }
}
