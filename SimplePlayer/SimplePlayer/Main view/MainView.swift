//
//  MainView.swift
//  SimplePlayer
//
//  Created by Александр on 09.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    
    func startSpinner() {
        activityIndicator.startAnimating()
    }
    
    func stopSpinner() {
        activityIndicator.stopAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        
        addSubviews([tableView, activityIndicator])
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
    }
    
    private func setUpConstraints() {
        
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
