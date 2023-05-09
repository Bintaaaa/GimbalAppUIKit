//
//  SearchViewController.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 09/05/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var games: [GameEntity] = []
    private var searchFilter: String = "a"
    private var search: String = ""
    
    @IBOutlet var searchView: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell{
            let game = games[indexPath.row]
            cell.titleOfGameTV.text = game.title
            cell.dateReleaseTV.text = "\(game.releseDate)"
            cell.levelingGameTV.text = "#\(game.level) Top 2023"
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
    
    
    fileprivate func startDownload(gamesEntity: GameEntity, indexPath: IndexPath){
        let imageDownload = ImageDownloader()
        if gamesEntity.state == .initial{
            Task{
                do{
                    let image = try await imageDownload.downloadImage(url: gamesEntity.imagePath)
                    gamesEntity.state = .hasData
                    gamesEntity.image = image
                    self.searchTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch{
                    gamesEntity.state = .error
                    gamesEntity.image = nil
                }
            }
        }
        
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
        
            search = searchFilter.filter({$0.description.contains(searchText)})
           
            Task{
                await getGames()
            }
        }
    }
    
    
    
    func getGames() async {
        let respository =  GamesRepository()
        do{
            games = try await respository.getGames(query: search)
        }catch {
            fatalError("Error: connection failed.")
        }
        self.searchTableView.reloadData()
    }
}
