//
//  GamesRepository.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import Foundation

private var apiKey: String{
    get{
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else{
            fatalError("Couldn't find file 'TMDB-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "API_KEY") as? String else{
            fatalError("Couldn't find value APiKey.")
        }
        return value
    }
}

class GamesRepository{
    let baseUrl = "https://api.rawg.io/api/"
    
    func getGames() async throws -> [GameEntity] {
        var components = URLComponents(string: "\(baseUrl)games")!
        
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
    
    func getDetail(id: Int32) async throws -> DetailGameEntity {
        var component = URLComponents(string: "\(baseUrl)games/\(id)")!
        component.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request  = URLRequest(url: component.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("this data of detail \(data)")
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            fatalError("Error: Can't fetching data. \(response)")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(DetailGame.self, from: data)
        
        return detailGameMapper(input: result)
    }
    
    func getGames(query: String) async throws -> [GameEntity] {
        var components = URLComponents(string: "\(baseUrl)games")!
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "search", value: query)
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
            return GameEntity(id: result.id!, title: result.name!, imagePath: result.imagePath!, level: result.ratingTop!, releaseDate: result.released!)
        }
    }
    fileprivate func detailGameMapper(input detailGame: DetailGame) -> DetailGameEntity{
        return DetailGameEntity(name: detailGame.name!, description: detailGame.description!, released: detailGame.released!, imagePath: detailGame.imagePath!, website: detailGame.website!, rating: detailGame.rating!, level: detailGame.level!)
    }
}
