//
//  Tweet.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/26/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: String?
    var text: String?
    var timestamp: Date?
    var retweeted: Bool = false
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var favorited: Bool = false
    var user: User! // author
    var inReplyToScreenname: String?

    init(dictionary: [String:Any]) {
        // added in v2
        user = User(dictionary: dictionary["user"] as! [String:Any])

        text = dictionary["text"] as? String // If text doesn't exist as key, then text will be nil because the cast will fail

        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        id = dictionary["id_str"] as? String
        retweeted = dictionary["retweeted"] as? Bool ?? false
        favorited = dictionary["favorited"] as? Bool ?? false
        
        //TODO Deal with RTs and the counts there
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            timestamp = Date(dateString: timestampString)
        }
        if let replyTo = dictionary["in_reply_to_screen_name"] as? String {
            inReplyToScreenname = "@\(replyTo)"
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
