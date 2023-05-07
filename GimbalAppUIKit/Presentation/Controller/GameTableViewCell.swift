//
//  GameTableViewCell.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet var levelingGameTV: UILabel!
    @IBOutlet var dateReleaseTV: UILabel!
    @IBOutlet var titleOfGameTV: UILabel!
    @IBOutlet var gameImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func stylingImage(){
        gameImageView.layer.cornerRadius = 18.0
    }
    
}
