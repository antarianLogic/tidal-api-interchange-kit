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
        let artistAndTracks = try await sut.getTracksForArtist(withID: id)
        #expect(artistAndTracks.data.id == "3565255")
        let artistAttributes = try #require(artistAndTracks.data.attributes)
        #expect(artistAttributes.name == "Pixies")
        let included = try #require(artistAndTracks.included)
        #expect(included.count == 20)
        let tracks = artistAndTracks.tracks
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
        #expect(album.data.id == "77610756")
        let attributes = try #require(album.data.attributes)
        #expect(attributes.title == "Nevermind")
        let included = try #require(album.included)
        #expect(included.count == 15)
        let tracks = album.tracks
        #expect(tracks.count == 13)
        let firstTrack = try #require(tracks.first)
        #expect(firstTrack.id == "77610757")
        #expect(firstTrack.attributes?.title == "Smells Like Teen Spirit")
        let lastTrack = try #require(tracks.last)
        #expect(lastTrack.id == "77610770")
        #expect(lastTrack.attributes?.title == "Endless, Nameless")
        let images = album.images
        #expect(images.count == 1)
        let firstImage = try #require(images.first)
        #expect(firstImage.attributes?.mediaType == "IMAGE")
        #expect(firstImage.id == "iWOu0yW0IPWzeVetoYT8")
        #expect(firstImage.attributes?.files.count == 7)
        let videos = album.videos
        #expect(videos.count == 1)
        let firstVideo = try #require(videos.first)
        #expect(firstVideo.attributes?.mediaType == "VIDEO")
        #expect(firstVideo.id == "iWOu6CXPguy46trJdwsY")
        #expect(firstVideo.attributes?.files.count == 7)
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

    @Test("Get albums with UPCs",
          arguments: [["811408033985"],
                      ["12345", "67890"],
                      [" abc "]])
    func getAlbums(upcs: [String]) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumsResource.Presets.upc811408033985)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let albums = try await sut.getAlbums(withUPCs: upcs)
        #expect(albums.count == 1)
        let firstAlbum = try #require(albums.first)
        #expect(firstAlbum.id == "168148780")
        let firstAlbumAttributes = try #require(firstAlbum.attributes)
        #expect(firstAlbumAttributes.title == "Nevermind")
    }

    @Test("Failing get albums with UPCs",
          arguments: [[""],
                      ["", " "],
                      [" "]])
    func failingGetAlbums(upcs: [String]) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumsResource.Presets.upc811408033985)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.getAlbums(withUPCs: upcs) }
        if case let .invalidInput(invalidUPCs) = error {
            #expect(invalidUPCs == upcs.joined(separator: ","))
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
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.chromatica)
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
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.chromatica)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.searchAlbums(withTitle: title, artistName: artist) }
        if case let .invalidInput(invalidText) = error {
            #expect(invalidText == title || invalidText == artist)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Search artists with name",
          arguments: [("Bad Bunny"),
                      ("bad bunny"),
                      (" bad Bunny")])
    func searchArtists(name: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.badBunny)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let artists = try await sut.searchArtists(withName: name)
        #expect(artists.count == 1)
        let firstArtist = try #require(artists.first)
        #expect(firstArtist.id == "8027279")
        let firstArtistAttributes = try #require(firstArtist.attributes)
        #expect(firstArtistAttributes.name == "Bad Bunny")
    }

    @Test("Failing search artists with name",
          arguments: [(""),
                      (" ")])
    func failingSearchArtists(name: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.badBunny)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.searchArtists(withName: name) }
        if case let .invalidInput(invalidName) = error {
            #expect(invalidName == name)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Search playlists with name",
          arguments: [("Shoegaze"),
                      ("shoegaze"),
                      ("  sHoEgAze ")])
    func searchPlaylists(name: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.shoegaze)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let playlists = try await sut.searchPlaylists(withName: name)
        #expect(playlists.count == 2)
        let firstPlaylist = try #require(playlists.first)
        #expect(firstPlaylist.id == "cf42bb98-2734-4cf5-9326-cce048b13388")
        let firstPlaylistAttributes = try #require(firstPlaylist.attributes)
        #expect(firstPlaylistAttributes.name == "Pillows of Noise: Shoegaze Classics")
    }

    @Test("Failing search playlists with name",
          arguments: [(""),
                      (" ")])
    func failingSearchPlaylists(name: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.shoegaze)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.searchPlaylists(withName: name) }
        if case let .invalidInput(invalidName) = error {
            #expect(invalidName == name)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Search top hits for text",
          arguments: [("Purple"),
                      ("purple"),
                      ("  pUrPle ")])
    func searchTopHits(text: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.purple)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let searchResults = try await sut.searchTopHits(withText: text)
        let included = try #require(searchResults.included)
        #expect(included.count == 100)
        let tracks = searchResults.tracks
        #expect(tracks.count == 60)
        let firstTrack = try #require(tracks.first)
        #expect(firstTrack.id == "103052575")
        let firstTrackAttributes = try #require(firstTrack.attributes)
        #expect(firstTrackAttributes.title == "Purple Swag REMIX (feat. Bun B, Paul Wall & Killa Kyleon)")
        let albums = searchResults.albums
        #expect(albums.count == 24)
        let firstAlbum = try #require(albums.first)
        #expect(firstAlbum.id == "110736761")
        let firstAlbumAttributes = try #require(firstAlbum.attributes)
        #expect(firstAlbumAttributes.title == "Purple Mountains")
        let artists = searchResults.artists
        #expect(artists.count == 5)
        let firstArtist = try #require(artists.first)
        #expect(firstArtist.id == "30109")
        let firstArtistAttributes = try #require(firstArtist.attributes)
        #expect(firstArtistAttributes.name == "Puddle Of Mudd")
        let playlists = searchResults.playlists
        #expect(playlists.count == 5)
        let firstPlaylist = try #require(playlists.first)
        #expect(firstPlaylist.id == "4775a202-3634-4a88-9b78-d05ca4367f21")
        let firstPlaylistAttributes = try #require(firstPlaylist.attributes)
        #expect(firstPlaylistAttributes.name == "PURPLE KISS: Live Session")
        let videos = searchResults.videos
        #expect(videos.count == 6)
        let firstVideo = try #require(videos.first)
        #expect(firstVideo.id == "136266483")
        let firstVideoAttributes = try #require(firstVideo.attributes)
        #expect(firstVideoAttributes.title == "Purple Rain (Live At Paisley Park, 1999)")
    }

    @Test("Failing search top hits for text",
          arguments: [(""),
                      (" ")])
    func failingSearchTopHits(text: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.purple)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.searchTopHits(withText: text) }
        if case let .invalidInput(invalidTitle) = error {
            #expect(invalidTitle == text)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Search tracks with title",
          arguments: [("Subbacultcha"),
                      ("subbacultcha"),
                      ("  sUbBaCuLtCha ")])
    func searchTracks(title: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.subbacultcha)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let tracks = try await sut.searchTracks(withTitle: title)
        #expect(tracks.count == 5)
        let firstTrack = try #require(tracks.first)
        #expect(firstTrack.id == "106473276")
        let firstTrackAttributes = try #require(firstTrack.attributes)
        #expect(firstTrackAttributes.title == "Subbacultcha")
    }

    @Test("Failing search tracks with title",
          arguments: [(""),
                      (" ")])
    func failingSearchTracks(title: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.subbacultcha)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.searchTracks(withTitle: title) }
        if case let .invalidInput(invalidTitle) = error {
            #expect(invalidTitle == title)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Search videos with title",
          arguments: [("Thriller"),
                      ("thriller"),
                      ("  tHrIlLer ")])
    func searchVideos(title: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.thriller)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let videos = try await sut.searchVideos(withTitle: title)
        #expect(videos.count == 17)
        let firstVideo = try #require(videos.first)
        #expect(firstVideo.id == "172607336")
        let firstVideoAttributes = try #require(firstVideo.attributes)
        #expect(firstVideoAttributes.title == "Thriller")
    }

    @Test("Failing search videos with title",
          arguments: [(""),
                      (" ")])
    func failingSearchVideos(title: String) async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalSearchResults.Presets.thriller)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAPIError.self) { try await sut.searchVideos(withTitle: title) }
        if case let .invalidInput(invalidTitle) = error {
            #expect(invalidTitle == title)
        } else {
            Issue.record("Not a TidalAPIError.invalidInput")
        }
    }

    @Test("Auth token invalid")
    func invalidAuthToken() async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.invalidToken)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumResource.Presets.nevermind)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        let error = await #expect(throws: TidalAuthError.self) { try await sut.getAlbum(withID: "77610756") }
        if case let .unexpectedTokenType(type) = error {
            #expect(type == "invalid")
        } else {
            Issue.record("Not a TidalAuthError.httpError")
        }
    }

    @Test("Auth token expired")
    func expiredAuthToken() async throws {
        let mockAuthManager = MockInterchangeManager()
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.validToken)
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.invalidToken)
        await mockAuthManager.pushMockData(TidalAuthResponse.Presets.nearlyExpired)
        let mockAPIManager = MockInterchangeManager()
        await mockAPIManager.pushMockData(TidalAlbumResource.Presets.nevermind)
        await mockAPIManager.pushMockData(TidalAlbumResource.Presets.nevermind)
        await mockAPIManager.pushMockData(TidalAlbumResource.Presets.nevermind)
        let sut = TidalAPIWorker(clientID: "FAKE_CLIENT_ID",
                                 clientSecret: "FAKE_CLIENT_SECRET",
                                 alternateAuthManager: mockAuthManager,
                                 alternateAPIManager: mockAPIManager)
        // first call should work since the first token in the mock data stack is not quite expired yet
        let album1 = try await sut.getAlbum(withID: "77610756")
        #expect(album1.data.id == "77610756")
        // make another call right away and it should work too as the token should still be good
        let album2 = try await sut.getAlbum(withID: "77610756")
        #expect(album2.data.id == "77610756")
        // this time, wait just over a second so old token will expire and need to be refreshed while the new one in
        // the mock data stack is invalid so now it should fail
        try await Task.sleep(nanoseconds: 1_100_000_000)
        let error = await #expect(throws: TidalAuthError.self) { try await sut.getAlbum(withID: "77610756") }
        if case let .unexpectedTokenType(type) = error {
            #expect(type == "invalid")
        } else {
            Issue.record("Not a TidalAuthError.httpError")
        }
        // now make a fourth call which should work since the final token in the mock data stack is good
        let album3 = try await sut.getAlbum(withID: "77610756")
        #expect(album3.data.id == "77610756")
    }
}
