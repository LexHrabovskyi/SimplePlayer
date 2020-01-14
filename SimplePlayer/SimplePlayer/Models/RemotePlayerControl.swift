//
//  RemotePlayerControl.swift
//  SwiftUIPlayer
//
//  Created by Александр on 01.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation
import MediaPlayer

final class RemotePlayerControl {
    
    private var playerManager: PlayerManager?
    private var wasInterrupted = false
    
    init(forController playerController: PlayerManager) {
        self.playerManager = playerController
        setupRemoteTransportControls()
    }
    
    private func setupRemoteTransportControls() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.seekForwardCommand.isEnabled = true

        commandCenter.seekBackwardCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = false
        
        commandCenter.playCommand.addTarget { [unowned playerManager] event in
            
            let isSuccess = playerManager?.remotePlay() ?? false
            return isSuccess ? .success : .commandFailed
            
        }
        
        commandCenter.pauseCommand.addTarget { [unowned playerManager] event in
            
            let isSuccess = playerManager?.remotePause() ?? false
            return isSuccess ? .success : .commandFailed
            
        }
        
        commandCenter.seekBackwardCommand.addTarget { [unowned playerManager] event in
            
            guard let controller = playerManager else { return .commandFailed }
            controller.backward15Sec()
            return .success
            
        }
        
        commandCenter.seekForwardCommand.addTarget { [unowned playerManager] event in
            
            guard let controller = playerManager else { return .commandFailed }
            controller.forward15Sec()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned playerManager] event in
            
            if let positionChangeEvent = event as? MPChangePlaybackPositionCommandEvent {
                let time = positionChangeEvent.positionTime
                playerManager?.rewindTime(to: time)
                return .success
            }

            return .commandFailed

        }
        
    }
    
    func updateNowPlaying() {
        
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        let song = playerManager!.getCurrentSong()
        nowPlayingInfo[MPNowPlayingInfoPropertyExternalUserProfileIdentifier] = "Simple Player"
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Simple Player"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = song?.url ?? "no url"
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerManager!.isPlaying
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
        
        if let durationInSeconds = playerManager?.getPlayingDuration() {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        }
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    func updateRemotePlayingTime(_ seconds: Double) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        nowPlayingInfoCenter.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seconds
    }
    
}
