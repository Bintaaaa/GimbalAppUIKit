//
//  FavoriteViewController.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 28/05/23.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    private var games: [GameEntity] = []

    @IBOutlet var favoriteGamesTableView: UITableView!
    
    private lazy var gamesContainer: GameContainer = {
        return GameContainer()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteGamesTableView.delegate = self
        favoriteGamesTableView.dataSource = self
        
        favoriteGamesTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGames()
    }
    
    fileprivate func startDownload(gamesEntity: GameEntity, indexPath: IndexPath){
        let imageDownload = ImageDownloader()
        if gamesEntity.state == .initial{
            Task{
                do{
                    let image = try await imageDownload.downloadImage(url: gamesEntity.imagePath!)
                    gamesEntity.state = .hasData
                    gamesEntity.image = image
                    self.favoriteGamesTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch{
                    gamesEntity.state = .error
                    gamesEntity.image = nil
                }
            }
        }
        
    }
    
    private func loadGames(){
        self.gamesContainer.getAllGames{result in
            DispatchQueue.main.async {
                self.games = result
                self.favoriteGamesTableView.reloadData()
            }
        }
    }
    
}


extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let game =  games[indexPath.row]
            
            cell.titleOfGameTV.text = game.title
            cell.dateReleaseTV.text = "\(game.releseDate!)"
            cell.levelingGameTV.text = "#\(game.level!) Top 2023"
            cell.gameImageView.image = game.image
            if game.state == .initial{
                cell.indicatorLoading.isHidden = false
                cell.indicatorLoading.startAnimating()
                startDownload(gamesEntity: game, indexPath: indexPath)
            }else{
                
                cell.indicatorLoading.stopAnimating()
                cell.indicatorLoading.isHidden = true
            }
            return cell
        }else{
            return GameTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailController = mainStoryBoard.instantiateViewController(withIdentifier: "detailScreen") as! DetailViewController
        let game = games[indexPath.row]
        
        
        detailController.id = game.id
        detailController.title = game.title
        
        UIApplication.shared.keyWindow?.rootViewController = detailController
    }
    
}
