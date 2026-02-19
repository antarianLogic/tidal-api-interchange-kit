//
//  TidalAPIError.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/14/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

public enum TidalAPIError: Error {
    case couldNotEscapeString(String)
    case invalidInput(String)
    case noItemsFound
}

extension TidalAPIError: Equatable {}

extension TidalAPIError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .couldNotEscapeString(rawString):
            return "Could not escape serach query string: \"\(rawString)\""
        case let .invalidInput(invalidString):
            return "Invalid input: \"\(invalidString)\""
        case .noItemsFound:
            return "No items found in search response"
        }
    }
}
