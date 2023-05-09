//
//  GameTableViewCell.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet var levelingGameTV: UILabel!
    @IBOutlet var dateReleaseTV: UILabel!
    @IBOutlet var titleOfGameTV: UILabel!
    @IBOutlet var gameImageView: UIImageView!
    @IBOutlet var indicatorCell: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        stylingImage()
    }
    
    
    
    func stylingImage(){
        gameImageView.layer.cornerRadius = 12.0
    }
    
}
