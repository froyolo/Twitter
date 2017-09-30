//
//  Tweet.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/26/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User! // author

    init(dictionary: [String:Any]) {
        // added in v2
        user = User(dictionary: dictionary["user"] as! [String:Any])

        text = dictionary["text"] as? String // If text doesn't exist as key, then text will be nil because the cast will fail
        // retweetCount = dictionary["retweet_count"] as! Int // The ! is slightly dangerous because if not exist so will crash.  Can do below instead
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            timestamp = Date(dateString: timestampString)
        }
        
        
    }
    
    // helper.  A class function
    class func tweetsWithArray(dictionaries: [[String:Any]]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            
        }
        return tweets
    }
    
}
