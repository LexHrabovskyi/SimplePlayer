//
//  AudioPlayerMOCK.swift
//  SimplePlayerTests
//
//  Created by Александр on 15.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation
import AVFoundation
@testable import SimplePlayer

class AudioPlayerMOCK: AudioPlayer {
    
    override func setCurrentItem(with song: Song) {

        guard let url = song.getFileURL() else { return }
        let playerItem = AVPlayerItem(url: url)
        self.replaceCurrentItem(with: playerItem)
        
        // can't change isPlaying state strictly, because of:
        // Global is external, but doesn't have external or weak linkage
        // so mimicre a little
        if !isPlaying {
            self.playPausePlayer()
        } else {
            self.play()
            isPlaying.toggle()
            isPlaying.toggle()
        }

    }
    
}

class SongMOCK {
    
    static let song1: Song = Song(id: 1, name: "Song 1", url: "test1")
    static let song2: Song = Song(id: 2, name: "Song 2", url: "test2")
    
}

fileprivate extension Song {
    
    func getFileURL() -> URL? {
        
        let songNumber = (url == "test1") ? 1 : 2
        let songPathString = "SoundHelix-Song-\(songNumber).mp3"
//        let path = Bundle.main.path(forResource: songPathString, ofType: "mp3")!
        let url = Bundle.main.url(forResource: songPathString, withExtension: nil)
        return url
        
    }
    
}
