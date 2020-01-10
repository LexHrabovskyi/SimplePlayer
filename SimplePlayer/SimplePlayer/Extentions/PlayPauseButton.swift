//
//  PlayPauseButton.swift
//  SimplePlayer
//
//  Created by Александр on 10.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation
import UIKit

class PlayPauseButton: UIButton {
    
    func setIcon(isPlaying: Bool) {
        
        let image = UIImage(systemName: isPlaying ? "pause" : "play")
        self.setImage(image, for: .normal)
        
    }
    
}
