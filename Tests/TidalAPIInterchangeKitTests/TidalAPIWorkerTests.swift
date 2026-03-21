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
        #expect(included.count == 21)
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
        let imageArtwork = artistAndTracks.imageArtwork
        #expect(imageArtwork.count == 1)
        let firstImage = try #require(imageArtwork.first)
        #expect(firstImage.attributes?.mediaType == "IMAGE")
        #expect(firstImage.id == "AmhFAmq4OGPBTbnvbkL")
        #expect(firstImage.attributes?.files.count == 4)
        let smallestImage = try #require(artistAndTracks.smallestImage)
        #expect(smallestImage.href == "https://resources.tidal.com/images/5d4aaf58/42cb/47a8/8846/cbf425b09944/160x160.jpg")
        #expect(smallestImage.meta?.width == 160)
        #expect(smallestImage.meta?.height == 160)
        let largestImage = try #require(artistAndTracks.largestImage)
        #expect(largestImage.href == "https://resources.tidal.com/images/5d4aaf58/42cb/47a8/8846/cbf425b09944/750x750.jpg")
        #expect(largestImage.meta?.width == 750)
        #expect(largestImage.meta?.height == 750)
        let smallestImageOver80 = try #require(artistAndTracks.smallestImageWithSizeAtLeast(width: 161, height: 161))
        #expect(smallestImageOver80.href == "https://resources.tidal.com/images/5d4aaf58/42cb/47a8/8846/cbf425b09944/320x320.jpg")
        #expect(smallestImageOver80.meta?.width == 320)
        #expect(smallestImageOver80.meta?.height == 320)
        let smallestImageAtLeast320 = try #require(artistAndTracks.smallestImageWithSizeAtLeast(width: 320, height: 320))
        #expect(smallestImageAtLeast320.href == "https://resources.tidal.com/images/5d4aaf58/42cb/47a8/8846/cbf425b09944/320x320.jpg")
        #expect(smallestImageAtLeast320.meta?.width == 320)
        #expect(smallestImageAtLeast320.meta?.height == 320)
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
        #expect(attributes.accessType == "PUBLIC")
        #expect(attributes.albumType == "ALBUM")
        #expect(attributes.barcodeID == "00602537498659")
        let copyright = try #require(attributes.copyright)
        #expect(copyright.text == "© 2011 Geffen Records")
        #expect(attributes.iso8601Duration == "PT49M23S")
        #expect(attributes.isExplicit == true)
        let externalLinks = try #require(attributes.externalLinks)
        #expect(externalLinks.count == 1)
        #expect(attributes.mediaTags.count == 2)
        #expect(attributes.numberOfItems == 13)
        #expect(attributes.numberOfVolumes == 1)
        #expect(attributes.popularity == 0.8484062030230879)
        #expect(attributes.iso8601ReleaseDate == "1991-09-24")
        let releaseDate = try #require(attributes.releaseDate)
        #expect(releaseDate.description == "1991-09-24 00:00:00 +0000")
        #expect(attributes.version == nil)
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
        let imageArtwork = album.imageArtwork
        #expect(imageArtwork.count == 1)
        let firstImage = try #require(imageArtwork.first)
        #expect(firstImage.attributes?.mediaType == "IMAGE")
        #expect(firstImage.id == "iWOu0yW0IPWzeVetoYT8")
        #expect(firstImage.attributes?.files.count == 7)
        let smallestImage = try #require(album.smallestImage)
        #expect(smallestImage.href == "https://resources.tidal.com/images/4e4aec29/deff/466e/9ea1/c47916d5960b/80x80.jpg")
        #expect(smallestImage.meta?.width == 80)
        #expect(smallestImage.meta?.height == 80)
        let largestImage = try #require(album.largestImage)
        #expect(largestImage.href == "https://resources.tidal.com/images/4e4aec29/deff/466e/9ea1/c47916d5960b/1280x1280.jpg")
        #expect(largestImage.meta?.width == 1280)
        #expect(largestImage.meta?.height == 1280)
        let smallestImageOver80 = try #require(album.smallestImageWithSizeAtLeast(width: 81, height: 81))
        #expect(smallestImageOver80.href == "https://resources.tidal.com/images/4e4aec29/deff/466e/9ea1/c47916d5960b/160x160.jpg")
        #expect(smallestImageOver80.meta?.width == 160)
        #expect(smallestImageOver80.meta?.height == 160)
        let smallestImageAtLeast320 = try #require(album.smallestImageWithSizeAtLeast(width: 320, height: 320))
        #expect(smallestImageAtLeast320.href == "https://resources.tidal.com/images/4e4aec29/deff/466e/9ea1/c47916d5960b/320x320.jpg")
        #expect(smallestImageAtLeast320.meta?.width == 320)
        #expect(smallestImageAtLeast320.meta?.height == 320)
        let videoArtwork = album.videoArtwork
        #expect(videoArtwork.count == 1)
        let firstVideo = try #require(videoArtwork.first)
        #expect(firstVideo.attributes?.mediaType == "VIDEO")
        #expect(firstVideo.id == "iWOu6CXPguy46trJdwsY")
        #expect(firstVideo.attributes?.files.count == 7)
        let trackData = try #require(album.data.relationships?.items.data)
        #expect(trackData.count == 13)
        let firstTrackData = try #require(trackData.first)
        #expect(firstTrackData.id == "77610757")
        #expect(firstTrackData.type == "tracks")
        let lastTrackData = try #require(trackData.last)
        #expect(lastTrackData.id == "77610770")
        #expect(lastTrackData.type == "tracks")
        let meta = try #require(firstTrackData.meta)
        #expect(meta.volumeNumber == 1)
        #expect(meta.trackNumber == 1)
        #expect(album.trackAt(volumeNumber: 0, trackNumber: 0) == nil)
        #expect(album.trackAt(volumeNumber: 0, trackNumber: 1) == nil)
        #expect(album.trackAt(volumeNumber: 1, trackNumber: 0) == nil)
        let trackOne = try #require(album.trackAt(volumeNumber: 1, trackNumber: 1))
        #expect(trackOne.id == "77610757")
        let trackFive = try #require(album.trackAt(volumeNumber: 1, trackNumber: 5))
        #expect(trackFive.id == "77610761")
        let trackThirteen = try #require(album.trackAt(volumeNumber: 1, trackNumber: 13))
        #expect(trackThirteen.id == "77610770")
        #expect(album.trackAt(volumeNumber: 1, trackNumber: 14) == nil)
        #expect(album.trackAt(volumeNumber: 2, trackNumber: 0) == nil)
        #expect(album.trackAt(volumeNumber: 2, trackNumber: 1) == nil)
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
        #expect(attributes.accessType == "PUBLIC")
        #expect(attributes.bpm == nil)
        let copyright = try #require(attributes.copyright)
        #expect(copyright.text == "4AD Ltd")
        #expect(attributes.iso8601CreatedAt == "2019-03-25T17:10:07Z")
        let creationDate = try #require(attributes.creationDate)
        #expect(creationDate.description == "2019-03-25 17:10:07 +0000")
        #expect(attributes.iso8601Duration == "PT2M10S")
        #expect(attributes.isExplicit == false)
        let externalLinks = try #require(attributes.externalLinks)
        #expect(externalLinks.count == 1)
        #expect(attributes.isrc == "GBAFL9100108")
        #expect(attributes.key == nil)
        #expect(attributes.keyScale == nil)
        #expect(attributes.mediaTags.count == 1)
        #expect(attributes.popularity == 0.5678694072557561)
        #expect(attributes.isSpotlighted == false)
        #expect(attributes.toneTags == nil)
        #expect(attributes.version == nil)
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
        #expect(firstPlaylistAttributes.accessType == "PUBLIC")
        #expect(firstPlaylistAttributes.isBounded == true)
        #expect(firstPlaylistAttributes.iso8601CreatedAt == "2016-10-18T15:03:21.652Z")
        let creationDate = try #require(firstPlaylistAttributes.creationDate)
        #expect(creationDate.description == "2016-10-18 15:03:21 +0000")
        #expect(firstPlaylistAttributes.description?.count == 956)
        #expect(firstPlaylistAttributes.iso8601Duration == "PT4H5M16S")
        #expect(firstPlaylistAttributes.externalLinks.count == 4)
        #expect(firstPlaylistAttributes.iso8601LastModifiedAt == "2026-03-01T23:48:49.772Z")
        let modificationDate = try #require(firstPlaylistAttributes.modificationDate)
        #expect(modificationDate.description == "2026-03-01 23:48:49 +0000")
        #expect(firstPlaylistAttributes.name == "Pillows of Noise: Shoegaze Classics")
        #expect(firstPlaylistAttributes.numberOfFollowers == 8550)
        #expect(firstPlaylistAttributes.numberOfItems == 50)
        #expect(firstPlaylistAttributes.playlistType == "EDITORIAL")
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
        let copyright = try #require(firstVideoAttributes.copyright)
        #expect(copyright.text == "FiXT")
        #expect(firstVideoAttributes.iso8601Duration == "PT5M52S")
        #expect(firstVideoAttributes.isExplicit == false)
        let externalLinks = try #require(firstVideoAttributes.externalLinks)
        #expect(externalLinks.count == 1)
        #expect(firstVideoAttributes.isrc == "QM5LC1700727")
        #expect(firstVideoAttributes.popularity == 0.06728918435585451)
        #expect(firstVideoAttributes.iso8601ReleaseDate == "2017-10-13")
        let releaseDate = try #require(firstVideoAttributes.releaseDate)
        #expect(releaseDate.description == "2017-10-13 00:00:00 +0000")
        #expect(firstVideoAttributes.title == "Thriller")
        #expect(firstVideoAttributes.version == "Lyric Video")
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
