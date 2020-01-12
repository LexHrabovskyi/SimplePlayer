//
//  PlayerViewController.swift
//  SimplePlayer
//
//  Created by Александр on 10.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import Combine

class PlayerViewController: UIViewController {
    
    let playerController: PlayerController
    private var song: Song
    private var contentView: PlayerView { return view as! PlayerView }
    
    private var songLenght: Double?
    private var loadingStatusSubscriber: AnyCancellable?
    private var playingSongSubscriber: AnyCancellable?
    private var currentTimeSubscriber: AnyCancellable?
    
    init(song: Song, for playerCotroller: PlayerController) {
        self.playerController = playerCotroller
        self.song = song
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = PlayerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.setSongName(song.name)
        
        contentView.playPauseButton.addTarget(self, action: #selector(playPauseSong), for: .touchUpInside)
        contentView.goBackButton.addTarget(self, action: #selector(backward15Sec), for: .touchUpInside)
        contentView.goForwardButton.addTarget(self, action: #selector(forward15Sec), for: .touchUpInside)
        contentView.slider.addTarget(self, action: #selector(rewindTime(_:)), for: .valueChanged)
        
        addBindings()
        
    }
    
    private func addBindings() {
        
        loadingStatusSubscriber = playerController.loadingStatusChanged.sink { [weak self, song] notLoaded in
       
            guard let self = self, self.playerController.isCurrentSong(song) else { return }
            
            if let lenght = self.playerController.getPlayingDuration() {
                let formattedLenght = self.toMinSec(lenght)
                self.contentView.setSongLenght(lenght, formatted: formattedLenght)
            }
            
            if notLoaded {
                self.contentView.startSpinner()
            } else {
                self.contentView.stopSpinner()
            }
        }
        
        playingSongSubscriber = playerController.playingSongPublisher.sink { [weak self, song] value in
            guard let self = self else { return }
            if value.1 && value.0 == song {
                self.contentView.setPlayPauseIcon(isPlaying: true)
            } else {
                self.contentView.setPlayPauseIcon(isPlaying: false)
            }
        }
        
        currentTimeSubscriber = playerController.timeChanged.sink { [weak self, song] value in
            
            guard let self = self, self.playerController.isCurrentSong(song) else { return }
            
            let formattedTime = self.toMinSec(value)
            self.contentView.setCurrentTime(Float(value), formatted: formattedTime)
        }
        
    }
    
    @objc private func playPauseSong() {
        playerController.playOrPause(song: song)
        guard songLenght == nil else { return }
        contentView.startSpinner()
    }
    
    @objc private func backward15Sec() {
        guard playerController.isCurrentSong(song) else { return }
        playerController.backward15Sec()
    }
    
    @objc private func forward15Sec() {
        guard playerController.isCurrentSong(song) else { return }
        playerController.forward15Sec()
    }
    
    @objc private func rewindTime(_ sender: UISlider) {
        guard playerController.isCurrentSong(song) else { return }
        playerController.rewindTime(to: Double(sender.value))
    }
    
    private func toMinSec(_ seconds : Double) -> String {
        let (_,  minf) = modf(seconds / 3600)
        let (min, secf) = modf(60 * minf)
        let seconds = Int(60 * secf)
        return "\(Int(min)):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
