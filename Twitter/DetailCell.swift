//
//  DetailCell.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/30/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    let favoritedImage = UIImage(named: "hearted")
    let unfavoritedImage = UIImage(named: "unhearted")
    let retweetedImage = UIImage(named: "retweet")
    let unretweetedImage = UIImage(named: "unretweet")
    
    var tweet: Tweet! {
        didSet{
            screennameLabel.text = tweet.user.screenname
            nameLabel.text = tweet.user?.name
            tweetTextLabel.text = tweet.text
            timestampLabel.text = tweet.timestamp?.toString()
            favoriteCountLabel.text = "\(tweet.favoritesCount)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
            
            if let profileImageURL = tweet.user?.profileUrl {
                profileImage.setImageWith(profileImageURL)
            }
            
            if tweet.retweeted {
                self.retweetButton.setImage(retweetedImage, for: UIControlState.normal)
            } else {
                self.retweetButton.setImage(unretweetedImage, for: UIControlState.normal)
            }
            
            if tweet.favorited {
                self.favoriteButton.setImage(favoritedImage, for: UIControlState.normal)
            } else {
                self.favoriteButton.setImage(unfavoritedImage, for: UIControlState.normal)
            }
        }
    }

    @IBAction func retweetTapped(_ sender: UIButton) {
        TwitterService.sharedInstance?.retweet(tweet: tweet, success: { (tweet) in
            self.retweetButton.setImage(self.retweetedImage, for: UIControlState.normal)
            self.retweetCountLabel.text = "\(tweet.retweetCount)" // Manually locally due to potential Twitter lag
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
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
        // Initialization code
        
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
