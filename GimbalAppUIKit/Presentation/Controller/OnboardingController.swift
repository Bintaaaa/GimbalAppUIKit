//
//  OnboardingController.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import UIKit

class OnboardingController: ViewController{
    @IBAction func btnMoveToHome(_ sender: Any) {
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeController = mainStoryBoard.instantiateViewController(identifier: "Home") as UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = homeController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
