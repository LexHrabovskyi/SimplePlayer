//
//  PlayerController.swift
//  SwiftUIPlayer
//
//  Created by Александр on 30.12.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import AVKit
import Combine
import SwiftUI

class PlayerController: ObservableObject {
    
    @Published var isLoading: Bool = false
    var loadingStatusChanged: AnyPublisher<Bool, Never>  {
        return $isLoading
            .eraseToAnyPublisher()
    }
    var playingSongPublisher: AnyPublisher<(Song?, Bool), Never> {
        return player.$isPlaying.map { value in
            (self.getCurrentSong(), value)
        }.eraseToAnyPublisher()
    }
    
    let playlist: Playlist
    fileprivate let player: AudioPlayer
    private var remoteContol: RemotePlayerControl? = nil
    
    init(player: AudioPlayer, for playlist: Playlist) {
        self.player = player
        self.playlist = playlist
        remoteContol = RemotePlayerControl(forController: self)
    }
    
    // MARK: player controls
    func playOrPause(song: Song) {
        
        guard song != playlist.currentSong else {
            player.playPausePlayer()
            return
        }
        
        playlist.setCurrentSong(song)
        isLoading = true
        player.setCurrentItem(with: song)
        
        // MARK: subscribing for beginning of song playing
        var waitingForStatusChanging: AnyCancellable?
        waitingForStatusChanging = player.timePlayerStatusChanged.sink { newStatus in
            
            guard newStatus == .playing else { return }
            
            self.remoteContol?.updateNowPlaying()
            self.isLoading = false
            waitingForStatusChanging?.cancel()
        }
        
    }
    
    func rewindTime(to seconds: Double) {
        let timeCM = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: timeCM)
        updateRemotePlayingTime(seconds: seconds)
    }
    
    func forward15Sec() {
        
        let currentTime = player.currentTimeInSeconds
        let songLenght = player.currentItem!.duration.seconds // TODO: need fix
        let forwardTime = songLenght > currentTime + 15.0 ? currentTime + 15.0 : songLenght
        
        rewindTime(to: forwardTime)
    }
    
    func backward15Sec() {
        let currentTime = player.currentTimeInSeconds
        let backwardTime = currentTime > 15.0 ? currentTime - 15.0 : 0.0
        rewindTime(to: backwardTime)
    }
    
    func getCurrentSong() -> Song? {
        return playlist.currentSong
    }
    
    func getPlayingDuration() -> Double? {
        return player.currentItem?.duration.seconds
    }
    
    // MARK: checking functions
    func nowPlaying(_ song: Song) -> Bool {
        return player.isPlaying && playlist.currentSong == song
    }
    
    func nowLoading(_ song: Song) -> Bool {
        return nowPlaying(song) && isLoading
    }
    
    func isCurrentSong(_ song: Song) -> Bool {
        return playlist.currentSong == song
    }
    
}

// MARK: extention for remote contols
extension PlayerController {
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    func remotePlay() -> Bool {
        
        guard !player.isPlaying, let _ = playlist.currentSong else { return false }
        
        player.playPausePlayer()
        return true
        
    }
    
    func remotePause() -> Bool {
        
        guard player.isPlaying else { return false }
        
        player.playPausePlayer()
        return true
        
    }
    
    func updateRemotePlayingTime(seconds: Double) {
        remoteContol?.updateRemotePlayingTime(seconds)
    }
    
}
