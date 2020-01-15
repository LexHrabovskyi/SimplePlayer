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
        
        playerManager.playOrPause(song: firstSong)
        wait(for: [expectEndPlaying], timeout: 1)
        XCTAssertFalse(audioPlayer.isPlaying)
        
        playerManager.playOrPause(song: firstSong)
        wait(for: [expectContinuePlaying], timeout: 1)
        XCTAssertTrue(audioPlayer.isPlaying)
        
        let secondSong = SongMOCK.song2
        playerManager.playOrPause(song: secondSong)
        wait(for: [expectChangeSong], timeout: 1)
        XCTAssertTrue(audioPlayer.isPlaying)
        
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
        
        wait(for: [expectLoadingDidEnd], timeout: 15)
        XCTAssertFalse(playerManager.isLoading)
        
    }


}
