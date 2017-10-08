//
//  User.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/26/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var posterUrl: URL?
    var followersCount: Int?
    var statusesCount: Int?
    var followingCount: Int?
    var dictionary: [String: Any]?
    
    
    static let userDidLogoutNotification = "UserDidLogout"
    static let currentUserKey = "   Data" // For UserDefaults
    static let accountsKey = "accountsData"
    
    static var _currentUser: User? // In v2, he declares this out of class User (var _currentUser: User)
    static var accounts: [String: User] = [String: User]()
    
    class var currentUser: User? {// May not exist
        get {
            if _currentUser == nil { // Check in storage
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: currentUserKey) as? Data
            
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _currentUser = User(dictionary: dictionary)
                }
                
                let accountsData = defaults.object(forKey: accountsKey) as? Data
                if let accountsData = accountsData {
                    let dictionary = try! JSONSerialization.jsonObject(with: accountsData, options: []) as! [String: [String:Any]]
                    
                    for (_, userdata) in dictionary {
                        let user = User(dictionary: userdata)
                        accounts[user.screenname!] = user
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user

            let defaults = UserDefaults.standard
            if let user = user {
                let currentUserdata = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(currentUserdata, forKey:currentUserKey)
                accounts[user.screenname!] = user
                
            } else {
                defaults.removeObject(forKey: currentUserKey)
            }
            
            // Save current list of accounts
            var accountsDictionary:[String: [String: Any]] = [String: [String: Any]]()
            for (_, user) in accounts {
                accountsDictionary[user.screenname!] = user.dictionary
            }
            
            let accountsdata = try! JSONSerialization.data(withJSONObject: accountsDictionary, options: [])
            defaults.set(accountsdata, forKey:accountsKey)
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

        let posterUrlString = dictionary["profile_banner_url"] as? String ?? dictionary["profile_background_image_url_https"] as? String// Can be nil
        if let posterUrlString = posterUrlString {
            posterUrl = URL(string: posterUrlString)
        } else {
            
        }
        
        tagline = dictionary["description"] as? String
    }
    
    func delete() {
        User.accounts.removeValue(forKey: screenname!)
        if User.currentUser?.screenname == screenname {
            User.currentUser = nil
            
            if User.accounts.count > 0 {
                User.currentUser = User.accounts.first?.value // Arbitrary pick the first user account to be the default now
            }
        }
        
        if User.accounts.count == 0 {
            TwitterService.sharedInstance?.logout()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
            
        } 
        
    }
    
}
