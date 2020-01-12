//
//  SongCellController.swift
//  SimplePlayer
//
//  Created by Александр on 09.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import Combine

final class SongCellController: UITableViewCell {
    
    private var song: Song?
    private var playerController: PlayerController?
    private var content: SongCellView?
    
    private var loadingStatusSubscriber: AnyCancellable?
    private var playingSongSubscriber: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setSong(_ song: Song, inController controller: PlayerController) {
        self.song = song
        self.playerController = controller
        self.content = SongCellView()
        content?.setSongName(song.name)
        content?.putContent(on: contentView)
        
        content?.playPauseButton.addTarget(self, action: #selector(playPauseMusic), for: .touchUpInside)
        
        addBindings()

    }
    
    private func addBindings() {
        
        loadingStatusSubscriber = playerController?.loadingStatusChanged.sink { [weak self, song] notLoaded in
            
            guard let currentSong = self?.playerController?.getCurrentSong(), song == currentSong else { return }
            
            if notLoaded {
                self?.content?.startSpinner()
            } else {
                self?.content?.stopSpinner()
            }
        }
        
        playingSongSubscriber = playerController?.playingSongPublisher.sink { [weak self, song] value in
            guard let self = self else { return }
            if value.1 && value.0 == song {
                self.content?.setPlayPauseIcon(isPlaying: true)
            } else {
                self.content?.setPlayPauseIcon(isPlaying: false)
            }
        }
        
    }
    
    @objc private func playPauseMusic(_ sender: UIButton) {
        guard let song = song else { return }
        playerController?.playOrPause(song: song)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        content?.removeFromSuperview()
        playerController = nil
        loadingStatusSubscriber = nil
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
