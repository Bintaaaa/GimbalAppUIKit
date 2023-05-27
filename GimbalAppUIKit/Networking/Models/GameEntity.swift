//
//  GameEntity.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import Foundation
import UIKit


enum DownloadImageState{ case initial, hasData, error }


class GameEntity{
    let id: Int32?
    let title: String?
    let releseDate: Date?
    let level: Int32?
    let imagePath: URL?
    
    var image: UIImage?
    var state: DownloadImageState = .initial
    
    
    init(
        id: Int32, title: String, imagePath: URL, level: Int32, releaseDate: Date
    ) {
        self.id = id
        self.title = title
        self.releseDate = releaseDate
        self.imagePath = imagePath
        self.level = level
    }
}


