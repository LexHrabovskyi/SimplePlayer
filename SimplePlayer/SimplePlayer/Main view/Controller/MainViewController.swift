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

    private(set) var viewModel: MainViewModel
    private var songBatchSubscriber: AnyCancellable?
    var tableView = UITableView()
    
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MainViewSongCell.self, forCellReuseIdentifier: "MainSongViewCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateList))
        
        // subscriber
        songBatchSubscriber = viewModel.newSongBatch.sink { [weak self] songBatch in
            guard self != nil else { return }
            let newIndexPaths = self!.getAddedIndexPaths(songBatch.count)
            self?.tableView.insertRows(at: newIndexPaths, with: .fade)
        }
        
    }
    
    @objc private func updateList() {
        viewModel.updateList()
    }

    private func getAddedIndexPaths(_ count: Int) -> [IndexPath] {
        
        var newIndexPaths = [IndexPath]()
        let lastRow = self.viewModel.songList.count
        for row in (lastRow - count)..<lastRow {
            newIndexPaths.append(IndexPath(row: row, section: 0))
        }
        
        return newIndexPaths
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

