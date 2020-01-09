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
        return playlist.songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.mainViewCell, for: indexPath) as! SongCellController
        
        let song = playlist.songList[indexPath.row]
        cell.setSong(song)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
