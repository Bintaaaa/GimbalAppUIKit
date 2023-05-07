//
//  GamesRepository.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import Foundation

class GamesRepository{
    let apiKey = "be6d699168dd40459ecb7fb37ea812fa"
    
    func getGames() async throws -> [GameEntity] {
        var components = URLComponents(string: "https://api.rawg.io/api/games")!
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard  (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data. \(response)")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GamesModel.self, from: data )
        return gamesMapper(input: result.games)
    }
}

extension GamesRepository {
  fileprivate func gamesMapper(
    input dataGamesModel: [DatasGameModel]
  ) -> [GameEntity] {
    return dataGamesModel.map { result in
        return GameEntity(title: result.name, imagePath: result.imagePath, level: result.ratingTop)
    }
  }
}
