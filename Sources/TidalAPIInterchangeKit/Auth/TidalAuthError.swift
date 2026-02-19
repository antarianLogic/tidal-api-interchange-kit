//
//  TidalAuthError.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/14/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

public enum TidalAuthError: Error {
    case nilAccessToken
    case unexpectedTokenType(String)
}

extension TidalAuthError: Equatable {}

extension TidalAuthError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .nilAccessToken:
            return "TIDAL access token is nil"
        case .unexpectedTokenType(let tokenType):
            return "Unexpected TIDAL access token type: \(tokenType)"
        }
    }
}
