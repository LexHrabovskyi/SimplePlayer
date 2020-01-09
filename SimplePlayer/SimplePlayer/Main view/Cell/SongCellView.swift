//
//  MainView.swift
//  SimplePlayer
//
//  Created by Александр on 03.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SnapKit

class SongCellView: UIView {
    
    private let playPauseImage = UIImageView()
    private let songName = UILabel()
    private let spinner = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
    }
    
    func setSongName(_ name: String) {
        songName.text = name
    }
    
    private func setUpSubviews() {
        
        addSubviews([playPauseImage, songName, spinner])
        
        playPauseImage.image = UIImage(systemName: "play") // TODO: reactive bindings
        
        spinner.hidesWhenStopped = true
        
    }
    
    private func setUpConstraints() {
        
        playPauseImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.height.width.equalTo(20)
        }
        
        songName.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(playPauseImage.snp.right).offset(16)
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
