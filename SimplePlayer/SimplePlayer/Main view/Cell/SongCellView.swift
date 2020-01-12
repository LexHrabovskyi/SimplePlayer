//
//  MainView.swift
//  SimplePlayer
//
//  Created by Александр on 03.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SnapKit

final class SongCellView: UIView {
    
    let playPauseButton = PlayPauseButton()
    private let songName = UILabel()
    private let spinner = UIActivityIndicatorView()
    
    // MARK: controls
    func putContent(on parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func setSongName(_ name: String) {
        songName.text = name
    }
    
    func setPlayPauseIcon(isPlaying: Bool) {
        playPauseButton.setIcon(isPlaying: isPlaying)
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
    
    // MARK: initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        
        addSubviews([playPauseButton, songName, spinner])
        
        playPauseButton.setIcon(isPlaying: false)
        
        spinner.hidesWhenStopped = true
        spinner.style = .medium
        
    }
    
    private func setUpConstraints() {
        
        playPauseButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.height.width.equalTo(20)
        }
        
        songName.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(playPauseButton.snp.right).offset(16)
            make.right.equalTo(spinner.snp.left).offset(16)
        }
        
        spinner.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
