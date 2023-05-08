//
//  DetailViewController.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 08/05/23.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var descriptionDetail: UILabel!
    
    @IBOutlet var ratingDetail: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var btnStyling: UIButton!
    var id: Int? = nil
    
    private var detail: DetailGameEntity?

    @IBOutlet var indicatorDetail: UIActivityIndicatorView!
    @IBAction func btnWeb(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            await getDetailGames()
            if let item = detail {
                ratingDetail.text = "\(item.rating)"
                descriptionDetail.text = item.description
            }
        }
        

    }
    

    func getDetailGames() async{
        let repository = GamesRepository()
        startLoading()
        do{
           detail = try await repository.getDetail(id: id!)
           stopLoading()
        }catch{
            fatalError("Error: connection failed.")
        }
    }
    
    
    func startLoading() {
        indicatorDetail.startAnimating()
        indicatorDetail.isHidden = false
    }

    func stopLoading() {
        indicatorDetail.stopAnimating()
        indicatorDetail.isHidden = true
    }
    


}
