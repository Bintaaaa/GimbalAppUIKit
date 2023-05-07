//
//  GamesModel.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import Foundation
struct GamesModel: Codable {
    let games: [DatasGameModel]
    
    enum CodingKeys: String, CodingKey{
        case games = "results"
    }
}
