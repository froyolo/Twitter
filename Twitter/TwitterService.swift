//
//  TwitterService.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/26/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


// Production app, we'd pull these from a plist (etc) instead of being backed into class
let twitterConsumerKey = "gGr4n5L5aQEUODLs9vIk1TUYV"
let twitterConsumerSecret = "O5cLsOMmQrP9CZZYB0qTtUzTayZKGjuHveA2ZoXHWpzhJ2Je5z"
let twitterBaseUrl = URL(string: "https://api.twitter.com")!

class TwitterService: BDBOAuth1SessionManager {
    static let sharedInstance: TwitterService! = TwitterService(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    // 2nd half of login process is in the app delegate 
    var loginSuccess: (() -> ())? // make it an optional
    var loginFailure: ((Error) -> ())?
    
    // sometimes people use completion instead of success.  Your choice
    func login(success: @escaping () -> (), failure: @escaping (Error)->()) {
        // Fetch request token & redirect to authorization page
        
        loginSuccess = success // Holds login closure until completion
        loginFailure = failure
        
        
        // Bug BDBO can be flaky if you don't log out.  Clears previous keychain sessions.
        deauthorize()
        
        // Get token so can send user to the authorize URL
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            if let requestToken = requestToken {
                let requestTokenString = requestToken.token ?? ""
    
                // Create URL with authorize URL and unwrap it by adding !
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestTokenString)")!

                // Switches application out of something else.  If is https, it'll open up Safari
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
               //UIApplication.shared.openURL(url)
            }
    
        }, failure: { (error:Error?) in
            print("error:\(String(describing: error?.localizedDescription))")
            self.loginFailure?((error)!)
        })
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        TwitterService.sharedInstance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.loginSuccess?()
            
            // Fetch current account
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })

            
        }, failure: { (error:Error?) in
            print("error:\(String(describing: error?.localizedDescription))")
            self.loginFailure?(error!)
        })
        
    }
    
    
    // Uses closures
    // When succeed, have closure where hand array of tweets, and don't need a response from you
    // When failure, give me error
    // ONce have closure, can store code given into thing called a success block
    // Pagination? Pack into a dictionary?  or what else?
    // v2 had 
    // func hometimeline(params: Dictionary?, completion:slkdfsldkjfsld, error: alskdjalskjdf)
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json?count=20", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                
            let dictionaries = response as! [[String: Any]]
            print(response!)
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries) // Can call function cuz it's a class function
            success(tweets) // Give it array of tweets, and cam run the code have   
            
        }, failure: { (task:URLSessionDataTask?, error: Error?) in
            failure((error)!)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error)->()) {
        let params = ["count":4]
        get("1.1/account/verify_credentials.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! [String: Any]
            let user = User(dictionary: userDictionary)

            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            failure((error)!)
        })
    }
    
 /*
 // Post a new tweet
 func postTweet(status: String, success: @escaping (Tweet) -> (), failure:
 @escaping (Error) -> ()) {
 
 let params: [String:Any] = [
 "status" : status
 ]
 
 post("1.1/statuses/update.json", parameters: params, progress: nil, success: {
 (task: URLSessionDataTask, response: Any?) in
 let tweet = Tweet(response as! NSDictionary)
 success(tweet)
 }) { (task: URLSessionDataTask?, error: Error) in
 failure(error)
 }
 */

    func logout () {
        User.currentUser = nil
        deauthorize()
        
        // Sometimes things can get into a bad state, good to clean things up.  Still need?!
        //TwitterService.sharedInstance?.requestSerializer.removeAccessToken()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
}
