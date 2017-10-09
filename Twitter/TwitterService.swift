//
//  TwitterService.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/26/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let twitterConsumerKey = "gGr4n5L5aQEUODLs9vIk1TUYV"
let twitterConsumerSecret = "O5cLsOMmQrP9CZZYB0qTtUzTayZKGjuHveA2ZoXHWpzhJ2Je5z"
let twitterBaseUrl = URL(string: "https://api.twitter.com")!


class TwitterService: BDBOAuth1SessionManager {
    static let sharedInstance: TwitterService! = TwitterService(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    var loginSuccess: (() -> ())? // make it an optional
    var loginFailure: ((Error) -> ())?
    
    func switchUser(success: @escaping () -> (), failure: @escaping (Error)->()) {
        login(success: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
            
        }) { (error: Error) in
            print("Error :\(error.localizedDescription)")
        }
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error)->()) {
        // Fetch request token & redirect to authorization page
        
        loginSuccess = success // Holds login closure until completion
        loginFailure = failure
        
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
    
    func mentionsTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                
                let dictionaries = response as! [[String: Any]]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries) // Can call function cuz it's a class function
                
                success(tweets) // Give it array of tweets, and cam run the code have
                
        }, failure: { (task:URLSessionDataTask?, error: Error?) in
            failure((error)!)
        })
    }
    
    
    func userTimeline(user: User!, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let params: [String:Any] = ["screen_name" : user.screenname!]
        get("1.1/statuses/user_timeline.json", parameters: params, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                
                let dictionaries = response as! [[String: Any]]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries) // Can call function cuz it's a class function
                
                success(tweets) // Give it array of tweets, and cam run the code have
                
        }, failure: { (task:URLSessionDataTask?, error: Error?) in
            failure((error)!)
        })
    }
    
    func homeTimeline(maxId: String?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var params: [String:Any] = ["count" : 20]
        if let maxId = maxId { // For finding older results
            let offset: Int64 = Int64(maxId)! - 1
            params["max_id"] = "\(offset)"
        }
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                
            let dictionaries = response as! [[String: Any]]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries) // Can call function cuz it's a class function
                
            success(tweets) // Give it array of tweets, and cam run the code have   
            
        }, failure: { (task:URLSessionDataTask?, error: Error?) in
            failure((error)!)
        })
    }
    
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error)->()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! [String: Any]
            let user = User(dictionary: userDictionary)

            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            failure((error)!)
        })
    }
    
    func postTweet(status: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params: [String:Any] = ["status" : status]
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! [String: Any]
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favoriteTweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let beforePostFavoritesCount = tweet.favoritesCount
        let params: [String:Any] = ["id" : tweet.id!]
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! [String: Any]
            let tweet = Tweet(dictionary: tweetDictionary)
            
            if !tweet.favorited || tweet.favoritesCount <= beforePostFavoritesCount {
                print("Twitter has update lag")
                // Manually set this locally.
                tweet.favoritesCount += 1
                tweet.favorited = true
            }
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unfavoriteTweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let beforePostFavoritesCount = tweet.favoritesCount
        let params: [String:Any] = ["id" : tweet.id!]
        post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! [String: Any]
            let tweet = Tweet(dictionary: tweetDictionary)

            if tweet.favorited || (tweet.favoritesCount >= beforePostFavoritesCount) {
                print("Twitter has update lag")
                // Manually set this locally.
                tweet.favoritesCount -= 1
                tweet.favorited = false
            }
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let beforePostRetweetCount = tweet.retweetCount
        
        post("1.1/statuses/retweet/\(tweet.id!).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionary = response as! [String: Any]
            let tweet = Tweet(dictionary: tweetDictionary)

            if !tweet.retweeted || (tweet.retweetCount <= beforePostRetweetCount) {
                print("Twitter has update lag")
                // Manually set this locally.
                tweet.retweetCount += 1
                tweet.retweeted = true
            }
            
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unretweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        if tweet.retweeted { // Can only unretweet a tweet that was retweeted

            // Determine the id of the original tweet
            var originalTweetId = tweet.id
            if tweet.retweetedTweet != nil {
                // Tweet was itself a retweet
                originalTweetId = tweet.retweetedTweet?.id
            }
        
            // Get the logged-in user's retweet
            var retweet: Tweet?
            var params: [String:Any] = ["include_my_retweet" : 1]
            params["id"] = originalTweetId
            get("1.1/statuses/show.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let retweetDictionary = response as! [String: Any]
                retweet = Tweet(dictionary: retweetDictionary)
                
                // Delete the retweet
                if let retweetId = retweet?.currentUserRetweetId {
                    self.post("1.1/statuses/destroy/\(retweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                        let tweetDictionary = response as! [String: Any]
                        let tweet = Tweet(dictionary: tweetDictionary)
                        
                        // Retweet successful, manually decrement the count of the original retweeted tweet to avoid lags
                        tweet.retweetCount -= 1
                        tweet.retweeted = false
                        
                        success(tweet)
                    }) { (task: URLSessionDataTask?, error: Error) in
                        failure(error)
                    }
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            }
        }
    }
    
    func repliedToTweet(tweet: Tweet, replyText: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        var params: [String:Any] = ["in_reply_to_status_id" : tweet.id!]
        params["status"] = replyText // The status text must include the screenname of the author of the referenced Tweet
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let tweetDictionary = response as! [String: Any]
                let tweet = Tweet(dictionary: tweetDictionary)
                success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }


    func logout () {
        User.currentUser = nil
        
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
}
