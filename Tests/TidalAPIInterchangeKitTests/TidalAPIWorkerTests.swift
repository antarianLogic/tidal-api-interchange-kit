//
//  TidalAPIWorkerTests.swift
//  TidalAPIInterchangeKitTests
//
//  Created by Carl Sheppard on 2/16/26.
//  Copyright © 2026 Antarian Logic LLC. All rights reserved.
//

import Testing
@testable import TidalAPIInterchangeKit
import Interchange
import TidalAPIDataPresets

struct TidalAPIWorkerTests {

    @Test("Get tracks for TIDAL artist ID",
          arguments: ["3565255",
                      " abc "])
    func getTracksForArtist(id: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalArtistTracks.Presets.pixies)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let tracks = try await sut.getTracksForArtist(withID: id)
        #expect(tracks.count == 20)
        let firstTrack = try #require(tracks.first)
        #expect(firstTrack.id == "2203300")
        let firstTrackAttributes = try #require(firstTrack.attributes)
        #expect(firstTrackAttributes.title == "Velouria")
        let lastTrack = try #require(tracks.last)
        #expect(lastTrack.id == "49794929")
        let lastTrackAttributes = try #require(lastTrack.attributes)
        #expect(lastTrackAttributes.title == "Where Is My Mind?")
    }

    @Test("Failing get tracks for TIDAL artist ID",
          arguments: ["",
                      " "])
    func failingGetTracksForArtist(id: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalArtistTracks.Presets.pixies)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.getTracksForArtist(withID: id) }
        if case let .invalidInput(invalidID) = error {
            #expect(invalidID == id)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Failing get tracks for TIDAL artist ID due to network error")
    func httpFailingGetTracksForArtist() async throws {
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: MockInterchangeManager(shouldFail: true),
                                 alternateAPIManager: MockInterchangeManager(shouldFail: true))
        let error = await #expect(throws: InterchangeError.self) { try await sut.getTracksForArtist(withID: "FAKE_ARTIST_ID") }
        if case let .httpError(code, _, _) = error {
            #expect(code == 404)
        } else {
            Issue.record("Not a InterchangeError.httpError")
        }
    }

    @Test("Get album with TIDAL ID",
          arguments: ["77610756",
                      " abc "])
    func getAlbum(id: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumResource.Presets.nevermind)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let album = try await sut.getAlbum(withID: id)
        #expect(album.id == "77610756")
        let attributes = try #require(album.attributes)
        #expect(attributes.title == "Nevermind")
    }

    @Test("Failing get album with TIDAL ID",
          arguments: ["",
                      " "])
    func failingGetAlbum(id: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumResource.Presets.nevermind)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.getAlbum(withID: id) }
        if case let .invalidInput(invalidID) = error {
            #expect(invalidID == id)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Get albums with UPC",
          arguments: ["811408033985",
                      " abc "])
    func getAlbums(upc: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumsResource.Presets.upc811408033985)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let albums = try await sut.getAlbums(withUPC: upc)
        #expect(albums.count == 1)
        let firstAlbum = try #require(albums.first)
        #expect(firstAlbum.id == "168148780")
        let firstAlbumAttributes = try #require(firstAlbum.attributes)
        #expect(firstAlbumAttributes.title == "Nevermind")
    }

    @Test("Failing get albums with UPC",
          arguments: ["",
                      " "])
    func failingGetAlbums(upc: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumsResource.Presets.upc811408033985)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.getAlbums(withUPC: upc) }
        if case let .invalidInput(invalidUPC) = error {
            #expect(invalidUPC == upc)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Get track with TIDAL ID",
          arguments: ["106473276",
                      " abc "])
    func getTrack(id: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalTrackResource.Presets.subbacultcha)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let track = try await sut.getTrack(withID: id)
        #expect(track.id == "106473276")
        let attributes = try #require(track.attributes)
        #expect(attributes.title == "Subbacultcha")
    }

    @Test("Failing get track with TIDAL ID",
          arguments: ["",
                      " "])
    func failingGetTrack(id: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalTrackResource.Presets.subbacultcha)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.getTrack(withID: id) }
        if case let .invalidInput(invalidID) = error {
            #expect(invalidID == id)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Search albums with title and artist",
          arguments: [("Chromatica", "Lady Gaga"),
                      ("chromatica", "lady gaga"),
                      ("Chromatica ", " lady Gaga"),
                      ("Chromatica (remastered)", "Lady Gaga")])
    func searchAlbums(title: String, artist: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumSearchResults.Presets.chromatica)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let albums = try await sut.searchAlbums(withTitle: title, artistName: artist)
        #expect(albums.count == 1)
        let firstAlbum = try #require(albums.first)
        #expect(firstAlbum.id == "143020722")
        let firstAlbumAttributes = try #require(firstAlbum.attributes)
        #expect(firstAlbumAttributes.title == "Chromatica")
    }

    @Test("Failing search albums with title and artist",
          arguments: [("", ""),
                      (" ", " "),
                      ("", "Lady Gaga"),
                      ("Chromatica", ""),
                      (" ", "Lady Gaga"),
                      ("Chromatica", " ")])
    func failingSearchAlbums(title: String, artist: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumSearchResults.Presets.chromatica)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.searchAlbums(withTitle: title, artistName: artist) }
        if case let .invalidInput(invalidID) = error {
            #expect(invalidID == title || invalidID == artist)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }
}
