//
//  TweetCell.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/28/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit
import NSDateMinimalTimeAgo

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyToScreennameLabel: UILabel!
    @IBOutlet weak var retweetedLabel: UIView!
    @IBOutlet weak var retweetButton: UIButton!    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetTextLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    let favoritedImage = UIImage(named: "hearted")
    let unfavoritedImage = UIImage(named: "unhearted")
    let retweetedImage = UIImage(named: "retweet")
    let unretweetedImage = UIImage(named: "unretweet")
    
    var tweet: Tweet! {
        didSet{
            if tweet.retweeted {
                retweetImage.isHidden = false
                retweetTextLabel.isHidden = false
            } else {
                retweetImage.isHidden = true
                retweetTextLabel.isHidden = true
            }
            
            if let tweetUser = tweet.user {
                screennameLabel.text = tweetUser.screenname!
                nameLabel.text = tweetUser.name!
                profileImage.setImageWith(tweetUser.profileUrl!)
            }
            tweetTextLabel.text = tweet.text
            
            if let replyTo = tweet.inReplyToScreenname {
                replyToScreennameLabel.text = "Replying to " + replyTo
            } else {
                replyToScreennameLabel.isHidden = true
            }
            
            if tweet.retweeted {
                retweetButton.setImage(retweetedImage, for: UIControlState.normal)
            } else {
                retweetButton.setImage(unretweetedImage, for: UIControlState.normal)
            }
            
            if tweet.favorited {
                favoriteButton.setImage(favoritedImage, for: UIControlState.normal)
            } else {
                favoriteButton.setImage(unfavoritedImage, for: UIControlState.normal)
            }
            
            timeAgoLabel.text = (tweet.timestamp! as NSDate).timeAgo()
            
        }
    }
    
    @IBAction func retweetTapped(_ sender: UIButton) {
        if tweet.retweeted { // Try to unretweet
            TwitterService.sharedInstance?.unretweet(tweet: tweet, success: { (tweet) in
                self.retweetButton.setImage(self.unretweetedImage, for: UIControlState.normal)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterService.sharedInstance?.retweet(tweet: tweet, success: { (tweet) in
                self.retweetButton.setImage(self.retweetedImage, for: UIControlState.normal)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        if tweet.favorited { // Trying to unfavorite
            TwitterService.sharedInstance?.unfavoriteTweet(tweet: tweet, success: { (tweet) in
                self.favoriteButton.setImage(self.unfavoritedImage, for: UIControlState.normal)
                self.tweet = tweet
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
        } else {
            TwitterService.sharedInstance?.favoriteTweet(tweet: tweet, success: { (tweet) in
                self.favoriteButton.setImage(self.favoritedImage, for: UIControlState.normal)
                self.tweet = tweet
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
