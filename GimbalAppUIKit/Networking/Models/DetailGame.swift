//
//  DetailGame.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 08/05/23.
//

import Foundation

struct DetailGame: Codable{
    let name: String
    let description: String
    let released: Date
    let imagePath: URL
    let website: URL
    let rating: Double
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case released
        case imagePath = "background_image"
        case website
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        description = try container.decode(String.self, forKey: .description)
        
        
        let dateString = try container.decode(String.self, forKey: .released)
        let dateFormatted = DateFormatter()
        dateFormatted.dateFormat = "yyyy-MM-dd"
        released = dateFormatted.date(from: dateString)!
        
        let path = try container.decode(String.self, forKey: .imagePath )
        imagePath = URL(string: path)!
        
        
        let urlWeb = try container.decode(String.self, forKey: .website)
        
        website = URL(string: urlWeb)!
        
        rating = try container.decode(Double.self, forKey: .rating)
    }
}
