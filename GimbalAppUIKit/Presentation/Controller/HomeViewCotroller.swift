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
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        
        gamesTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
    }
    
    @IBOutlet var indicatorHome: UIActivityIndicatorView!
    override func viewWillAppear(_ animated: Bool) {
        Task {await getGames()}
    }
    
    func getGames() async{
        let repository = GamesRepository()
        startLoading()
        do{
            games = try await repository.getGames()
            gamesTableView.reloadData()
            stopLoading()
            
        }catch{
            
            fatalError("Error: connection failed.")
        }
    }
    
    fileprivate func startDownload(gamesEntity: GameEntity, indexPath: IndexPath){
        let imageDownload = ImageDownloader()
        if gamesEntity.state == .initial{
            Task{
                do{
                    let image = try await imageDownload.downloadImage(url: gamesEntity.imagePath!)
                    gamesEntity.state = .hasData
                    gamesEntity.image = image
                    self.gamesTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch{
                    gamesEntity.state = .error
                    gamesEntity.image = nil
                }
            }
        }
        
    }
    
    func startLoading() {
        indicatorHome.startAnimating()
        indicatorHome.isHidden = false
    }
    
    func stopLoading() {
        indicatorHome.stopAnimating()
        indicatorHome.isHidden = true
    }
}


extension HomeViewCotroller: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell{
            let game = games[indexPath.row]
            
            
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
            return UITableViewCell()
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
