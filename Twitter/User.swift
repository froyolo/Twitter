//
//  User.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/26/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

let currentUserKey = "currentUserData" // For UserDefaults


class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var dictionary: [String: Any]?
    var posterUrl: URL?
    var followersCount: Int?
    var statusesCount: Int?
    var followingCount: Int?
    
    static var _currentUser: User? // In v2, he declares this out of class User (var _currentUser: User)
    static let userDidLogoutNotification = "UserDidLogout"
    
    class var currentUser: User? {// May not exist
        get {
            if _currentUser == nil { // Check in storage
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: currentUserKey) as? Data
            
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            // Will save the user everything do a user.currentuser = <something>
            let defaults = UserDefaults.standard
            if let user = user {
                // Try block - acknowledge it can fail, but let it go.
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey:currentUserKey)
            } else {
                //defaults.set(nil, forKey: currentUserKey)
                defaults.removeObject(forKey: currentUserKey)
            }
            defaults.synchronize() // save to disk
        }
    }
    
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = "@" + (dictionary["screen_name"] as! String)
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String // Can be nil
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        followersCount = dictionary["followers_count"] as? Int
        statusesCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int

        let posterUrlString = dictionary["profile_banner_url"] as? String // Can be nil
        if let posterUrlString = posterUrlString {
            posterUrl = URL(string: posterUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
}
