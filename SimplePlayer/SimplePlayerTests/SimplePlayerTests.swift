//
//  SimplePlayerTests.swift
//  SimplePlayerTests
//
//  Created by Александр on 10.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import XCTest
import Combine
@testable import SimplePlayer

class SimplePlayerTests: XCTestCase {

    var playerManager: PlayerManager!
    var playlist: Playlist!
    var audioPlayer: AudioPlayerMOCK!
    
    override func setUp() {
        super.setUp()
        audioPlayer = AudioPlayerMOCK()
        playlist = Playlist()
        playerManager = PlayerManager(player: audioPlayer, for: playlist)
    }
    
    func testManagerStartsWithEmptyPlaylist() {
        
        XCTAssertEqual(playlist.songList.count, 0)
        XCTAssertNil(playerManager.getCurrentSong())
        
    }
    
    func testUpdatingPlaylist() {
        
        let expectFirstUpdate = expectation(description: "waiting first batch")
        let expectSecondUpdate = expectation(description: "waiting second batch")
        
        let subscriber = playlist.newSongBatch.sink { _ in
            if self.playlist.songList.count == 10 {
                expectFirstUpdate.fulfill()
            } else if self.playlist.songList.count == 20 {
                expectSecondUpdate.fulfill()
            }
        }
        
        playlist.updateList()
        wait(for: [expectFirstUpdate], timeout: 2)
        XCTAssertEqual(playlist.songList.count, 10)
        
        playlist.updateList()
        wait(for: [expectSecondUpdate], timeout: 2)
        XCTAssertEqual(playlist.songList.count, 20)
        
    }
    
    // TODO: maybe better divide to 3 different tests
    func testIsPlayingStatus() {
        
        let expectBeginPlaying = expectation(description: "now playing")
        let expectEndPlaying = expectation(description: "not playing")
        let expectContinuePlaying = expectation(description: "continue playing")
        let expectChangeSong = expectation(description: "changing song, which must play")
        var testStep = 0
        
        let subscriber = audioPlayer.$isPlaying.sink { _ in
            
            guard testStep != 0 else { testStep += 1; return }
            
            switch testStep {
            case 1:
                expectBeginPlaying.fulfill()
            case 2:
                expectEndPlaying.fulfill()
            case 3:
                expectContinuePlaying.fulfill()
            case 4:
                print("MOCK audio toggles twice")
            case 5:
                expectChangeSong.fulfill()
            default:
                fatalError("unexpected step")
            }
            
            testStep += 1
            
        }
        
        let firstSong = SongMOCK.song1
        playerManager.playOrPause(song: firstSong)
        wait(for: [expectBeginPlaying], timeout: 1)
        XCTAssertTrue(audioPlayer.isPlaying)
        XCTAssertTrue(playerManager.nowPlaying(firstSong))
        XCTAssertTrue(playerManager.isCurrentSong(firstSong))
        
        playerManager.playOrPause(song: firstSong)
        wait(for: [expectEndPlaying], timeout: 1)
        XCTAssertFalse(audioPlayer.isPlaying)
        XCTAssertFalse(playerManager.nowPlaying(firstSong))
        XCTAssertTrue(playerManager.isCurrentSong(firstSong))
        
        playerManager.playOrPause(song: firstSong)
        wait(for: [expectContinuePlaying], timeout: 1)
        XCTAssertTrue(audioPlayer.isPlaying)
        XCTAssertTrue(playerManager.nowPlaying(firstSong))
        
        let secondSong = SongMOCK.song2
        playerManager.playOrPause(song: secondSong)
        wait(for: [expectChangeSong], timeout: 1)
        XCTAssertTrue(audioPlayer.isPlaying)
        XCTAssertTrue(playerManager.nowPlaying(secondSong))
        XCTAssertTrue(playerManager.isCurrentSong(secondSong))
        
    }
    
    func testLoadingStatusChanging() {
        
        let expectLoadingDidBegin = expectation(description: "begin loading")
        let expectLoadingDidEnd = expectation(description: "end loading")
        var testStep = 0
        
        let subscriber = playerManager.$isLoading.sink { _ in
            
            guard testStep != 0 else { testStep += 1; return } //
            
            switch testStep {
            case 1:
                expectLoadingDidBegin.fulfill()
            case 2:
                expectLoadingDidEnd.fulfill()
            default:
                print("some other step?")
            }
            
            testStep += 1
            
        }
        
        let testSong = SongMOCK.song1
        playerManager.playOrPause(song: testSong)
        wait(for: [expectLoadingDidBegin], timeout: 1)
        XCTAssertTrue(playerManager.isLoading)
        XCTAssertTrue(playerManager.nowLoading(testSong))
        
        wait(for: [expectLoadingDidEnd], timeout: 15)
        XCTAssertFalse(playerManager.isLoading)
        
    }
    
    func testTimeChanging() {
        
        let expctTime = expectation(description: "waiting for time changing")
        expctTime.expectedFulfillmentCount = 5
        
        var results = [Int]()
        
        var testStep = 0
        
        let subscriber = playerManager.timeChanged.sink { time in
            guard testStep > 1 else { testStep += 1; return }
            expctTime.fulfill()
            results.append(Int(time))
            testStep += 1
        }
        
        let testSong = SongMOCK.song1
        playerManager.playOrPause(song: testSong)
        
        waitForExpectations(timeout: 10)
        
        guard results.count == expctTime.expectedFulfillmentCount else {
            XCTAssertEqual(results.count, expctTime.expectedFulfillmentCount)
            return
        }
        
        for resultIndex in 0..<expctTime.expectedFulfillmentCount {
            XCTAssertEqual(results[resultIndex], resultIndex)
        }
        
    }
    
    func testSongDuration() {
        
        let expctFirstTimeChanging = expectation(description: "waiting for loading and song begining")
        
        let subscriber = playerManager.timeChanged.sink { time in
            guard time > 1.0 else { return }
            expctFirstTimeChanging.fulfill()
        }
        
        let testSong = SongMOCK.song1
        playerManager.playOrPause(song: testSong)
        wait(for: [expctFirstTimeChanging], timeout: 3)
        XCTAssertNotNil(playerManager.getPlayingDuration())
        let songDuration = Int(playerManager.getPlayingDuration() ?? 0.0)
        XCTAssertEqual(songDuration, 372)
        
    }
    
    func testTimeConrol() {
        
        let expctFirstTimeChanging = expectation(description: "waiting for loading and song begining")
        let expctFirstForward = expectation(description: "first forwarded")
        let expctSecondForward = expectation(description: "second forwarded")
        let expctBackward = expectation(description: "backwarded")
        
        var forwardedTimes = 0
        var backwardedTimes = 0
        var testStep = 0
        
        let timeSubscriber = playerManager.timeChanged.sink { time in
            
            guard time > 1.0 else { return }
            
            if testStep == 0 {
                expctFirstTimeChanging.fulfill()
            } else if forwardedTimes == 0 {
                // forwarded first time
                forwardedTimes += 1
                expctFirstForward.fulfill()
            } else if forwardedTimes == 1 {
                forwardedTimes += 1
                expctSecondForward.fulfill()
            } else if forwardedTimes == 2 {
                expctBackward.fulfill()
            }
            
            testStep += 1
            
        }
        
        let testSong = SongMOCK.song1
        playerManager.playOrPause(song: testSong)
        wait(for: [expctFirstTimeChanging], timeout: 3)
        
        playerManager.forward15Sec()
        wait(for: [expctFirstForward], timeout: 1)
        XCTAssertTrue(audioPlayer.currentTimeInSeconds > 15.0)
        
        playerManager.forward15Sec()
        wait(for: [expctSecondForward], timeout: 1)
        XCTAssertTrue(audioPlayer.currentTimeInSeconds > 30.0)
        
        playerManager.backward15Sec()
        wait(for: [expctBackward], timeout: 1)
        XCTAssertTrue(audioPlayer.currentTimeInSeconds < 30)
        XCTAssertTrue(audioPlayer.currentTimeInSeconds > 15.0)
        
    }
    
    func testRewindAndFinishSong() {
        
        let expctFirstTimeChanging = expectation(description: "waiting for loading and song begining")
        let expctTimeRewind = expectation(description: "waiting for rewind time")
        let expctSongDidEnd = expectation(description: "waiting for song end")
        
        var songDidBegin = false
        var timeDidRewind = false
        
        let timeSubscriber = playerManager.timeChanged.sink { time in
            guard time > 1.0 else { return }
            
            if !songDidBegin {
                songDidBegin = true
                expctFirstTimeChanging.fulfill()
            } else if !timeDidRewind {
                timeDidRewind = true
                expctTimeRewind.fulfill()
            }
        }
        
        let endSubscriber = audioPlayer.songDidEnd.sink { didEnd in
//            guard didEnd else { return }
            expctSongDidEnd.fulfill()
        }
        
        let testSong = SongMOCK.song1
        playerManager.playOrPause(song: testSong)
        wait(for: [expctFirstTimeChanging], timeout: 3)
        
        playerManager.rewindTime(to: 371.0)
        wait(for: [expctTimeRewind], timeout: 1)
        XCTAssertEqual(Int(audioPlayer.currentTimeInSeconds), 371)
        
        wait(for: [expctSongDidEnd], timeout: 3)
        XCTAssertFalse(audioPlayer.isPlaying)
        
    }

}
