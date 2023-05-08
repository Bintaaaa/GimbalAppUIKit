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
    let id: Int
    let title: String
    let releseDate: Date
    let imagePath: URL
    let level: Int
    
    var image: UIImage?
    var state: DownloadImageState = .initial
   
    
    init(
        id: Int, title: String, imagePath: URL, level: Int, releaseDate: Date
    ) {
        self.id = id
        self.title = title
        self.releseDate = releaseDate
        self.imagePath = imagePath
        self.level = level
    }
}


