//
//  SongModel.swift
//  SimplePlayer
//
//  Created by Александр on 06.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

struct Song: Hashable, Codable, Identifiable, Equatable {
    
    let id: Int
    let name: String
    let url: String
    
}
