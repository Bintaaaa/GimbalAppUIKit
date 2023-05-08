//
//  DatasGameModel.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import Foundation

struct DatasGameModel: Codable{
    let id: Int
    let name: String
    let released: Date
    let imagePath: URL
    let ratingTop: Int
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case released
        case imagePath = "background_image"
        case ratingTop = "rating_top"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        
        name = try container.decode(String.self, forKey: .name)

        let dateString = try container.decode(String.self, forKey: .released)

        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            released = dateFormatter.date(from: dateString)!
        
        let path = try container.decode(String.self, forKey: .imagePath )
        
       imagePath = URL(string: path)!
        
        ratingTop = try container.decode(Int.self, forKey: .ratingTop)
    }
    
}
