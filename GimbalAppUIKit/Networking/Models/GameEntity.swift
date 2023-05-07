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
    let title: String
//    let releseDate: Date
    let imagePath: URL
    let level: Int
    
    var image: UIImage?
    var state: DownloadImageState = .initial
    
    init(title: String, imagePath: URL, level: Int
    ) {
        self.title = title
//        self.releseDate = releseDate
        self.imagePath = imagePath
        self.level = level
    }
}
