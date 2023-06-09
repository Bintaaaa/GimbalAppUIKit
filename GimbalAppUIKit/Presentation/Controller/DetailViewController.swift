//
//  DetailViewController.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 08/05/23.
//

import UIKit

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private lazy var gameContainer: GameContainer = {
        return GameContainer()
    }()
    
    @IBOutlet var descriptionDetail: UILabel!
    
    @IBOutlet var favoriteImageVIew: UIImageView!
    @IBOutlet var starImage: UIImageView!
    @IBOutlet var ratingDetail: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var btnStyling: UIButton!
    var id: Int32? = nil
    
    private var detail: DetailGameEntity?
    
    private var isFavorite: Bool? = nil
    
    @IBOutlet var titleGamesLabel: UILabel!
    @IBOutlet var levelGames: UILabel!
    @IBOutlet var indicatorDetail: UIActivityIndicatorView!
    @IBAction func btnWeb(_ sender: Any) {
        let url: URL = detail?.website ?? URL(string: "https://bijantyum.space/")!
        UIApplication.shared.open(url)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configImage()
        startLoading()
        Task{
            await getDetailGames()
            if indicatorDetail.isHidden {
                if let item = detail {
                    ratingDetail.text = String(describing: item.rating)
                    descriptionDetail.text = item.description
                    titleGamesLabel.text = item.name
                    levelGames.text = "#\(String(describing: item.level!)) Top Games"
                    if item.state == .initial{
                        startDownloadImage(detailGameEntity: detail!)
                    }
                }
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadIsfavorite()
    }
    
    @IBAction func backButton(_ sender: Any) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailController = mainStoryBoard.instantiateViewController(withIdentifier: "Home") as! TabbarContoller
        UIApplication.shared.keyWindow?.rootViewController = detailController
    }
    
    func getDetailGames() async{
        let repository = GamesRepository()
        startLoading()
        do{
            detail = try await repository.getDetail(id: id!)
            stopLoading()
        }catch{
            stopLoading()
            fatalError("Error: connection failed.")
        }
    }
    
    fileprivate func startDownloadImage(detailGameEntity: DetailGameEntity){
        let imageDownloader = ImageDownloader()
        Task{
            do{
                let result = try await  imageDownloader.downloadImage(url: (detailGameEntity.imagePath)!)
                detailGameEntity.state = .hasData
                DispatchQueue.main.async {
                    self.detailImage.image = result
                }
            }
            catch{
                detailGameEntity.image = nil
                detailGameEntity.state = .error
            }
        }
    }
    
    
    func startLoading() {
        indicatorDetail.startAnimating()
        favoriteImageVIew.isHidden = true
        indicatorDetail.isHidden = false
        ratingDetail.isHidden = true
        titleGamesLabel.isHidden = true
        detailImage.isHidden = true
        descriptionDetail.isHidden = true
        btnStyling.isHidden = true
        levelGames.isHidden = true
        ratingDetail.isHidden = true
        starImage.isHidden = true
    }
    
    func stopLoading() {
        indicatorDetail.stopAnimating()
        indicatorDetail.isHidden = true
        detailImage.isHidden = false
        favoriteImageVIew.isHidden = false
        levelGames.isHidden = false
        titleGamesLabel.isHidden = false
        descriptionDetail.isHidden = false
        btnStyling.isHidden = false
        ratingDetail.isHidden = false
        starImage.isHidden = false
    }
    
    func loadIsfavorite(){
        gameContainer.isFavorite(id: id!){result in
            self.isFavorite = result
            DispatchQueue.main.async {
                if(self.isFavorite ?? false){
                    self.favoriteImageVIew.image = UIImage(systemName: "heart.fill")
                }
            }
        }
    }
    
    func configImage(){
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTap))
        favoriteImageVIew.addGestureRecognizer(gesture)
        favoriteImageVIew.isUserInteractionEnabled = true
    }
    
    @objc func imageTap(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            if(isFavorite ?? false){
                gameContainer.deleteFavorite(id: id!){
                    DispatchQueue.main.async {
                        self.favoriteImageVIew.image = UIImage(systemName: "heart")
                        let alert = UIAlertController(title: "Deleted", message: "Favorite is deleted", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                        self.isFavorite = false
                       
                    }
                }
            }else{
                gameContainer.addToFavorite(id: id!, title: detail!.name!, image: detail!.imagePath!, level: detail!.level!, releeaseDate: detail!.released!){
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Successful", message: "New member created.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                        self.loadIsfavorite()
                    }
                }
            }
        }
    }
    
    
    
}
