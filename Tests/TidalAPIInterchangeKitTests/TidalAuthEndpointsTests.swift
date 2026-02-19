//
//  TidalAuthEndpointsTests.swift
//  TidalAPIInterchangeKitTests
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Testing
@testable import TidalAPIInterchangeKit

struct TidalAuthEndpointsTests {

    @Test func baseURL() async throws {
        #expect(TidalAuthEndpoints.baseURL.absoluteString == "https://auth.tidal.com/v1")
    }

    @Test func authToken() async throws {
        let endpoint = TidalAuthEndpoints.authToken(clientID: "fake_id", clientSecret: "fake_secret")
        #expect(endpoint.path == "/oauth2/token")
        #expect(endpoint.headers == ["Authorization" : "Basic ZmFrZV9pZDpmYWtlX3NlY3JldA==",
                                     "Content-Type": "application/x-www-form-urlencoded"])
        #expect(endpoint.queryParameters.isEmpty)
        #expect(endpoint.body == "grant_type=client_credentials")
        #expect(endpoint.pageSizeQueryItem == nil)
        #expect(endpoint.offsetQueryItem == nil)
        #expect(endpoint.pageQueryItem == nil)
        #expect(endpoint.cacheInterval == nil)
    }
}
