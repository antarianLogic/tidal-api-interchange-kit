//
//  TidalAuthEndpoints.swift
//  TidalAPIInterchangeKit
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Foundation
import Interchange

public enum TidalAuthEndpoints {

    /// A constant representing the TIDAL base URL for authorization requests
    ///
    public static let baseURL: URL = {
        guard let url = URL(string: "https://auth.tidal.com/v1") else { fatalError("Invalid TIDAL auth base URL!") }

        return url
    }()

    /// Creates an endpoint suitable to return a TIDAL access token
    ///
    /// - Parameters:
    ///   - clientID: TIDAL Client ID string copied from the TIDAL developer dashboard
    ///   - clientSecret: TIDAL Client Secret string copied from the TIDAL developer dashboard
    /// - Returns: RESTEndpoint
    ///
    /// ## Usage
    ///
    /// Use this endpoint with the ``TidalAuthEndpoints.baseURL`` to retrieve the TIDAL access token with ``InterchangeManager``'s ``sendRequest(with: endpoint)``, setting the result type to the ``TidalAuthResponse`` model type.
    /// For example:
    ///
    /// ```swift
    /// let authManager = InterchangeManager(baseURL: TidalAuthEndpoints.baseURL)
    /// var accessToken: String?
    ///
    /// let endpoint = TidalAuthEndpoints.getAuthToken(clientID: "YOUR_CLIENT_ID",
    ///                                                clientSecret: "YOUR_CLIENT_SECRET")
    /// do {
    ///     let response: TidalAuthResponse = try await authManager.sendRequest(with: endpoint)
    ///
    ///     accessToken = response.accessToken
    /// } catch {
    ///     print("Auth error: \(error.localizedDescription)")
    /// }
    /// ```
    public static func authToken(clientID: String,
                                 clientSecret: String) -> RESTEndpoint {
        let idAndSecret = "\(clientID):\(clientSecret)"
        let encodedValue = Data(idAndSecret.utf8).base64EncodedString()
        let authHeaders: [String : String] = ["Content-Type" : "application/x-www-form-urlencoded",
                                              "Authorization" : "Basic \(encodedValue)"]
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [URLQueryItem(name: "grant_type", value: "client_credentials")]
        return RESTEndpoint(method: .post,
                            path: "/oauth2/token",
                            headers: authHeaders,
                            body: bodyComponents.query)
    }
}
