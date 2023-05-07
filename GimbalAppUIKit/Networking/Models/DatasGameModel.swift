//
//  DatasGameModel.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import Foundation

struct DatasGameModel: Codable{
    let name: String
//    let released: Date
    let imagePath: URL
    let ratingTop: Int
    
    enum CodingKeys: String, CodingKey{
        case name
//        case released
        case imagePath = "background_image"
        case ratingTop = "rating_top"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
//
//        let dateString = try container.decode(String.self, forKey: .released)
//
//            let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        released = dateFormatter.date(from: dateString) ??  dateFormatter.date(from: "2023-04-01")!
        
        let path = try container.decode(String.self, forKey: .imagePath )
        
       imagePath = URL(string: path)!
        
        ratingTop = try container.decode(Int.self, forKey: .ratingTop)
    }
    
}