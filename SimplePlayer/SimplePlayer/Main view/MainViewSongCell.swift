//
//  MainView.swift
//  SimplePlayer
//
//  Created by Александр on 03.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SnapKit

class MainViewSongCell: UITableViewCell {
    
    // TODO: customize for playing song cell
    let myLabel = UILabel()
    let myButton = UIButton()
    
    init() {
        super.init(style: .default, reuseIdentifier: "MainSongViewCell")
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        
        addSubviews([myLabel, myButton])
        
        myLabel.text = "myLabel"
        
        myButton.setTitle("Применить", for: .normal)
        myButton.setTitleColor(.white, for: .normal)
        myButton.layer.cornerRadius = 4
        
    }
    
    private func setUpConstraints() {
        
        myLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(10)
        }
        
        myButton.snp.makeConstraints { (make) in
            make.top.equalTo(myLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
