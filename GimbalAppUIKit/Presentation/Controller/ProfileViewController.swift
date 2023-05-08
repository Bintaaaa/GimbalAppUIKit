//
//  ProfileViewController.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBAction func profileBtn(_ sender: Any) {
        
        guard let url = URL(string: "https://bijantyum.space/#/") else {return}
        
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
        
      
    }
    
   

}
