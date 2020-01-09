//
//  ViewController.swift
//  SimplePlayer
//
//  Created by Александр on 03.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import Combine

class MainViewController: UIViewController {

    private(set) var playlist: Playlist
    var contentView: MainView { return view as! MainView }
    private var songBatchSubscriber: AnyCancellable?
    
    init(viewModel: Playlist = Playlist()) {
        self.playlist = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        contentView.tableView.register(SongCellController.self, forCellReuseIdentifier: CellReuseIdentifiers.mainViewCell)
        
        navigationItem.title = "From soundhelix.com"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateList))
        
        setUpBindings()
        
        updateList() // getting first 10 songs
        
    }
    
    private func setUpBindings() {
        
        songBatchSubscriber = playlist.newSongBatch.sink { [weak self] songBatch in
            guard self != nil else { return }
            self?.contentView.stopSpinner()
            let newIndexPaths = self!.getAddedIndexPaths(songBatch.count)
            self?.contentView.tableView.insertRows(at: newIndexPaths, with: .fade)
        }
        
    }
    
    @objc private func updateList() {
        contentView.startSpinner()
        playlist.updateList()
    }

    private func getAddedIndexPaths(_ count: Int) -> [IndexPath] {
        
        var newIndexPaths = [IndexPath]()
        let lastRow = self.playlist.songList.count
        for row in (lastRow - count)..<lastRow {
            newIndexPaths.append(IndexPath(row: row, section: 0))
        }
        
        return newIndexPaths
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

