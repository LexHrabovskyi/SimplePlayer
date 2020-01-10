//
//  PlayerView.swift
//  SimplePlayer
//
//  Created by Александр on 10.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SnapKit
import MediaPlayer

class PlayerView: UIView {
    
    // TODO: maybe better divide on 2 different views, like controls and slider
    let playPauseButton = PlayPauseButton()
    let goBackButton = UIButton()
    let goForwardButton = UIButton()
    let slider = UISlider()
    private let songName = UILabel()
    private let currentTime = UILabel()
    private let songLenght = UILabel()
    private let volumeView = MPVolumeView()
    private let spinner = UIActivityIndicatorView()
    
    func setSongName(_ name: String) {
        songName.text = name
    }
    
    func setPlayPauseIcon(isPlaying: Bool) {
        playPauseButton.setIcon(isPlaying: isPlaying)
    }
    
    func setSongLenght(_ lenght: String) {
        songLenght.text = lenght
    }
    
    func startSpinner() {
        spinner.startAnimating()
        songLenght.alpha = 0.01
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
        songLenght.alpha = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundColor()
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setBackgroundColor() {
        let darkMode = self.traitCollection.userInterfaceStyle == .dark
        backgroundColor = darkMode ? .black : .white
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setBackgroundColor()
    }
    
    private func setUpSubviews() {
        
        addSubviews([songName, playPauseButton, goBackButton, goForwardButton, slider, currentTime, songLenght, volumeView, spinner])
        
        playPauseButton.setIcon(isPlaying: false)
        
        
        let goBackImage = UIImage(systemName: "gobackward.15")
        
        goBackButton.setImage(goBackImage, for: .normal)
        
        let goForwardImage = UIImage(systemName: "goforward.15")
        goForwardButton.setImage(goForwardImage, for: .normal)
        
        // some slider options?
        songName.font = UIFont(name: "system", size: 36)
        songName.textAlignment = .center
        songName.numberOfLines = 0
        songName.text = "Undefined"
        
        currentTime.text = "0:00"
        currentTime.textAlignment = .right
        songLenght.text = "0:00"
        
        spinner.hidesWhenStopped = true
        
    }
    
    private func setUpConstraints() {
        
        // MARK: buttons
        playPauseButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        playPauseButton.imageView?.snp.makeConstraints { (make) in
            make.width.height.equalTo(55)
        }
        
        goBackButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(playPauseButton)
            make.right.equalTo(playPauseButton.snp.left).offset(-24)
        }
        
        goBackButton.imageView?.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
        }
        
        goForwardButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(playPauseButton)
            make.left.equalTo(playPauseButton.snp.right).offset(24)
        }
        
        goForwardButton.imageView?.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
        }
        
        // MARK: song name
        songName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(playPauseButton.snp.top).offset(-24)
        }
        
        // MARK: slider
        currentTime.snp.makeConstraints { (make) in
            make.top.equalTo(playPauseButton.snp.bottom).offset(36)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(50)
        }
        
        songLenght.snp.makeConstraints { (make) in
            make.centerY.equalTo(currentTime)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(50)
        }
        
        slider.snp.makeConstraints { (make) in
            make.centerY.equalTo(currentTime)
            make.left.equalTo(currentTime.snp.right).offset(16)
            make.right.equalTo(songLenght.snp.left).offset(-16)
        }
        
        // MARK: volume view
        volumeView.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(slider)
        }
        
        // MARK: spinner view
        spinner.snp.makeConstraints { (make) in
            make.centerX.equalTo(songLenght)
            make.centerY.equalTo(songLenght)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
