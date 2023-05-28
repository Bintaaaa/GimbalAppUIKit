//
//  ProfileModel.swift
//  GimbalAppUIKit
//
//  Created by Bijantyum on 28/05/23.
//

import Foundation

struct ProfileModel{
    static let description = "description"
    
    static var desc: String{
        get {
            return UserDefaults.standard.string(forKey: description) ?? "Aku Bijan, Lagi banyak eksplore di dunia mobile dan Improve di Native. Mohon bimbingannya kakak reviewer. Thank You!"
        }
        set{
            UserDefaults.standard.set(newValue, forKey: description)
        }
    }
    
    static func delete() -> Bool {
        if let domain = Bundle.main.bundleIdentifier{
            UserDefaults.standard.removePersistentDomain(forName: domain)
            synchronize()
            return true
        }else{
            return false
        }
    }
    static func synchronize() {
      UserDefaults.standard.synchronize()
    }
}
