//
//  MainViewModel.swift
//  SimplePlayer
//
//  Created by Александр on 03.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation
import Combine

final class MainViewModel {
    
    var newSongBatch = PassthroughSubject<[Song], Never>()
    var subscribtions = [AnyCancellable]()
    
    @Published var songList: [Song] = load("SongList.json")
    private var beginningPage: Int = 1
    
    func updateList() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            var newSongs = [Song]()
            let startNumber = self.beginningPage * 10
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
    
}

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
    
}
