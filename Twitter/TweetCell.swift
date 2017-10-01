//
//  TweetCell.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/28/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

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
    
    var tweet: Tweet! {
        didSet{
            if tweet.retweeted {
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
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
