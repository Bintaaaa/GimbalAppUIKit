//
//  DetailGameEntity.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 08/05/23.
//

import Foundation
import UIKit

enum DetailGameState {case initial, hasData, error}
class DetailGameEntity{
    let name: String?
    let description: String?
    let released: Date?
    let imagePath: URL?
    let website: URL?
    let rating: Double?
    let level: Int32?
    
    
    
    var image: UIImage?
    var state: DetailGameState = .initial
    
    init(name: String, description: String, released: Date, imagePath: URL, website: URL, rating: Double, level: Int32) {
        self.name = name
        self.description = description
        self.released = released
        self.imagePath = imagePath
        self.website = website
        self.rating = rating
        self.level =  level
    }
    
}
