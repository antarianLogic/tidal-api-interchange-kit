//
//  TidalAPIEndpointsTests.swift
//  TidalAPIInterchangeKitTests
//
//  Created by Carl Sheppard on 2/13/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Testing
@testable import TidalAPIInterchangeKit

struct TidalAPIEndpointsTests {

    @Test func baseURL() async throws {
        #expect(TidalAPIEndpoints.baseURL.absoluteString == "https://openapi.tidal.com/v2")
    }

    @Test func artistsTracks() async throws {
        let endpoint = TidalAPIEndpoints.artistsTracks(withID: "fake_id", accessToken: "fake_token")
        #expect(endpoint.path == "/artists/fake_id/relationships/tracks")
        #expect(endpoint.headers == ["Authorization" : "Bearer fake_token",
                                     "Accept": "application/vnd.api+json"])
        #expect(endpoint.queryParameters.count == 3)
        #expect(endpoint.queryParameters[0].name == "collapseBy")
        #expect(endpoint.queryParameters[0].value == "FINGERPRINT")
        #expect(endpoint.queryParameters[1].name == "countryCode")
        #expect(endpoint.queryParameters[1].value == "US")
        #expect(endpoint.queryParameters[2].name == "include")
        #expect(endpoint.queryParameters[2].value == "tracks")
        #expect(endpoint.body == nil)
        #expect(endpoint.pageSizeQueryItem == nil)
        #expect(endpoint.offsetQueryItem == nil)
        #expect(endpoint.pageQueryItem == nil)
        #expect(endpoint.cacheInterval == nil)
    }

    @Test func getAlbum() async throws {
        let endpoint = TidalAPIEndpoints.getAlbum(withID: "fake_id", accessToken: "fake_token")
        #expect(endpoint.path == "/albums/fake_id")
        #expect(endpoint.headers == ["Authorization" : "Bearer fake_token",
                                     "Accept": "application/vnd.api+json"])
        #expect(endpoint.queryParameters.count == 1)
        #expect(endpoint.queryParameters[0].name == "countryCode")
        #expect(endpoint.queryParameters[0].value == "US")
        #expect(endpoint.body == nil)
        #expect(endpoint.pageSizeQueryItem == nil)
        #expect(endpoint.offsetQueryItem == nil)
        #expect(endpoint.pageQueryItem == nil)
        #expect(endpoint.cacheInterval == nil)
    }

    func getAlbums() async throws {
        let endpoint = TidalAPIEndpoints.getAlbums(withUPC: "fake_upc", accessToken: "fake_token")
        #expect(endpoint.path == "/albums")
        #expect(endpoint.headers == ["Authorization" : "Bearer fake_token",
                                     "Accept": "application/vnd.api+json"])
        #expect(endpoint.queryParameters.count == 2)
        #expect(endpoint.queryParameters[0].name == "countryCode")
        #expect(endpoint.queryParameters[0].value == "US")
        #expect(endpoint.queryParameters[1].name == "filter[barcodeId]")
        #expect(endpoint.queryParameters[1].value == "fake_upc")
        #expect(endpoint.body == nil)
        #expect(endpoint.pageSizeQueryItem == nil)
        #expect(endpoint.offsetQueryItem == nil)
        #expect(endpoint.pageQueryItem == nil)
        #expect(endpoint.cacheInterval == nil)
    }

    @Test func getTrack() async throws {
        let endpoint = TidalAPIEndpoints.getTrack(withID: "fake_id", accessToken: "fake_token")
        #expect(endpoint.path == "/tracks/fake_id")
        #expect(endpoint.headers == ["Authorization" : "Bearer fake_token",
                                     "Accept": "application/vnd.api+json"])
        #expect(endpoint.queryParameters.count == 1)
        #expect(endpoint.queryParameters[0].name == "countryCode")
        #expect(endpoint.queryParameters[0].value == "US")
        #expect(endpoint.body == nil)
        #expect(endpoint.pageSizeQueryItem == nil)
        #expect(endpoint.offsetQueryItem == nil)
        #expect(endpoint.pageQueryItem == nil)
        #expect(endpoint.cacheInterval == nil)
    }

    @Test func searchAlbums() async throws {
        let endpoint = TidalAPIEndpoints.search(withQuery: "Chromatica%20-%20Lady%20Gaga", type: .albums, accessToken: "fake_token")
        #expect(endpoint.path == "/searchResults/Chromatica%20-%20Lady%20Gaga")
        #expect(endpoint.headers == ["Authorization" : "Bearer fake_token",
                                     "Accept": "application/vnd.api+json"])
        #expect(endpoint.queryParameters.count == 3)
        #expect(endpoint.queryParameters[0].name == "countryCode")
        #expect(endpoint.queryParameters[0].value == "US")
        #expect(endpoint.queryParameters[1].name == "explicitFilter")
        #expect(endpoint.queryParameters[1].value == "INCLUDE")
        #expect(endpoint.queryParameters[2].name == "include")
        #expect(endpoint.queryParameters[2].value == "albums")
        #expect(endpoint.body == nil)
        #expect(endpoint.pageSizeQueryItem == nil)
        #expect(endpoint.offsetQueryItem == nil)
        #expect(endpoint.pageQueryItem == nil)
        #expect(endpoint.cacheInterval == nil)
    }
}
