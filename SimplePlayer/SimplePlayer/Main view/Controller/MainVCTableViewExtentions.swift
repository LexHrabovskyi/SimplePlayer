//
//  MainVCTableViewExtentions.swift
//  SimplePlayer
//
//  Created by Александр on 06.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let songData = viewModel.songList[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = songData.name
        cell.detailTextLabel?.text = songData.url
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
