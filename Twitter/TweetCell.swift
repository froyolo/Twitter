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
    
    var tweet: Tweet! {
        didSet{
            screennameLabel.text = tweet.user?.screenname
            nameLabel.text = tweet.user?.name
            tweetTextLabel.text = tweet.text
            
            if let profileImageURL = tweet.user?.profileUrl {
                profileImage.setImageWith(profileImageURL)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
