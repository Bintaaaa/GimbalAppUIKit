//
//  DetailViewController.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 08/05/23.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var descriptionDetail: UILabel!
    
    @IBOutlet var starImage: UIImageView!
    @IBOutlet var ratingDetail: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var btnStyling: UIButton!
    var id: Int? = nil
    
    private var detail: DetailGameEntity?
    
    @IBOutlet var titleGamesLabel: UILabel!
    @IBOutlet var levelGames: UILabel!
    @IBOutlet var indicatorDetail: UIActivityIndicatorView!
    @IBAction func btnWeb(_ sender: Any) {
        let url: URL = detail?.website ?? URL(string: "https://bijantyum.space/")!
        UIApplication.shared.open(url)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    func getDetailGames() async{
        let repository = GamesRepository()
        do{
            startLoading()
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
        indicatorDetail.isHidden = false
        detailImage.isHidden = true
        descriptionDetail.isHidden = true
        btnStyling.isHidden = true
        ratingDetail.isHidden = true
        starImage.isHidden = true
    }
    
    func stopLoading() {
        indicatorDetail.stopAnimating()
        indicatorDetail.isHidden = true
        detailImage.isHidden = false
        descriptionDetail.isHidden = false
        btnStyling.isHidden = false
        ratingDetail.isHidden = false
        starImage.isHidden = false
    }
    
    
    
}