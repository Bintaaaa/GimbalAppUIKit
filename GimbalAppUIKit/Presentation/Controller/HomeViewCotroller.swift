//
//  HomeViewCotroller.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import UIKit

class HomeViewCotroller: UIViewController {

    @IBOutlet var gamesTableView: UITableView!
    
    private var games: [GameEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gamesTableView.dataSource = self
        gamesTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {await getGames()}
    }
    
    func getGames() async{
        let repository = GamesRepository()
        do{
            games = try await repository.getGames()
            gamesTableView.reloadData()
        }catch{
            fatalError("Error: connection failed.")
        }
    }
}


extension HomeViewCotroller: UITableViewDataSource, UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell{
            let game = games[indexPath.row]
            cell.titleOfGameTV.text = game.title
//            cell.dateReleaseTV.text = "\(game.releseDate)"
            cell.levelingGameTV.text = "#\(game.level) Top 2023"
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
}
