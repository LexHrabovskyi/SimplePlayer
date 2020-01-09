//
//  MainViewModel.swift
//  SimplePlayer
//
//  Created by Александр on 03.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation
import Combine

final class Playlist {
    
    var newSongBatch = PassthroughSubject<[Song], Never>()
    
    var songList: [Song] = [Song]()
    @Published var currentSong: Song? = nil
    private var beginningPage: Int = 0
    
    func setCurrentSong(_ song: Song) {
         currentSong = song
    }
    
    func updateList() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // simulating API delay
            
            var newSongs = [Song]()
            let startNumber = self.beginningPage * 10 + 1
            for songNumber in startNumber...startNumber + 9 {
                
                let newSong = Song(id: 1000 + songNumber
                    , name: "SoundHelix Song \(songNumber)"
                    , url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-\(songNumber).mp3")
                
                newSongs.append(newSong)
            }
            
            self.beginningPage += 1
            self.songList.append(contentsOf: newSongs)
            self.newSongBatch.send(newSongs)
            
        }
        
    }
    
    // TODO: maybe delete
    func setNextSong(_ backward: Bool = false) {
        
        guard let _ = currentSong else {
            currentSong = songList.first!
            return
        }
        
        let currentIndex = songList.firstIndex(of: currentSong!)!
        var nextIndex = 0
        
        if backward {
            let zeroIndex = currentIndex == 0
            nextIndex = zeroIndex ? songList.count - 1 : currentIndex - 1
        } else {
            let lastIndex = (currentIndex == songList.count - 1)
            nextIndex = lastIndex ? 0 : currentIndex + 1
        }
        
        currentSong = songList[nextIndex]
        
    }
    
}
