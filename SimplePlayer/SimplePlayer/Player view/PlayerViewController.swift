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
    
    init(song: Song, for playerCotroller: PlayerController) {
        self.playerController = playerCotroller
        self.song = song
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = PlayerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
