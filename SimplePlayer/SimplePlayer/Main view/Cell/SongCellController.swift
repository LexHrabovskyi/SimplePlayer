//
//  SongCellController.swift
//  SimplePlayer
//
//  Created by Александр on 09.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SnapKit

class SongCellController: UITableViewCell {
    
    private var song: Song?
    private var content: SongCellView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setSong(_ song: Song) {
        self.song = song
        self.content = SongCellView()
        content?.setSongName(song.name)

        // TODO: bring it to view?
        addSubview(content!)
        content!.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        content?.removeFromSuperview()
        // delete bindings
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
