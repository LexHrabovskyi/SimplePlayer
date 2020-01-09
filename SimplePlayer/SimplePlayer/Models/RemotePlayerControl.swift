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
    
    private var playerController: PlayerController?
    private var wasInterrupted = false
    
    init(forController playerController: PlayerController) {
        self.playerController = playerController
        setupRemoteTransportControls()
    }
    
    private func setupRemoteTransportControls() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.seekForwardCommand.isEnabled = true

        commandCenter.seekBackwardCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = false
        
        commandCenter.playCommand.addTarget { [unowned playerController] event in
            
            let isSuccess = playerController?.remotePlay() ?? false
            return isSuccess ? .success : .commandFailed
            
        }
        
        commandCenter.pauseCommand.addTarget { [unowned playerController] event in
            
            let isSuccess = playerController?.remotePause() ?? false
            return isSuccess ? .success : .commandFailed
            
        }
        
        commandCenter.seekBackwardCommand.addTarget { [unowned playerController] event in
            
            guard let controller = playerController else { return .commandFailed }
            controller.backward15Sec()
            return .success
            
        }
        
        commandCenter.seekForwardCommand.addTarget { [unowned playerController] event in
            
            guard let controller = playerController else { return .commandFailed }
            controller.forward15Sec()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned playerController] event in
            
            if let positionChangeEvent = event as? MPChangePlaybackPositionCommandEvent {
                let time = positionChangeEvent.positionTime
                playerController?.rewindTime(to: time)
                return .success
            }

            return .commandFailed

        }
        
    }
    
    func updateNowPlaying() {
        
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        let song = playerController!.getCurrentSong()
        nowPlayingInfo[MPNowPlayingInfoPropertyExternalUserProfileIdentifier] = "Simple Player"
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Simple Player"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = song?.url ?? "no url"
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerController!.isPlaying
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
        
        if let durationInSeconds = playerController?.getPlayingDuration() {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        }
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    func updateRemotePlayingTime(_ seconds: Double) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        nowPlayingInfoCenter.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seconds
    }
    
}
