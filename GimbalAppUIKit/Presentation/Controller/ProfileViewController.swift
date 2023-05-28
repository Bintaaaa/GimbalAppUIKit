//
//  ProfileViewController.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 07/05/23.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet var viewConstraintToDescription: NSLayoutConstraint!
    
    @IBOutlet var viewConstraintToBtnDone: NSLayoutConstraint!
    @IBOutlet var doneBtnStyle: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var btnEdit: UIImageView!
    
    
    @IBAction func doneBtn(_ sender: Any) {
    }
    @IBAction func profileBtn(_ sender: Any) {
        
        guard let url = URL(string: "https://bijantyum.space/#/") else {return}
        
        UIApplication.shared.open(url)
    }
    
    private var isTap: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtnStyle.isHidden = true
        descriptionTextField.isHidden = true
        configImage()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    
    
    func configImage(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        btnEdit.addGestureRecognizer(gesture)
        btnEdit.isUserInteractionEnabled = true
    }
    
    @objc func imageTap(){
        isTap = !isTap
        if isTap {
            doneBtnStyle.isHidden = false
            descriptionTextField.isHidden = false
            btnEdit.image = UIImage(systemName: "xmark.circle")
        } else{
            doneBtnStyle.isHidden = true
            descriptionTextField.isHidden = true
            btnEdit.image = UIImage(systemName: "pencil")
        }
        
    }
    
    
}
