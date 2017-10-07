//
//  ProfileCell.swift
//  Twitter
//
//  Created by Ngan, Naomi on 10/5/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsNumberLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    
    var user: User! {
        didSet {
            if let poster = user.posterUrl {
                posterImage.setImageWith(poster)
            }
            
            screennameLabel.text = user.screenname!
            nameLabel.text = user.name!
            profileImage.setImageWith(user.profileUrl!)
            profileImage.layer.borderWidth = 3
            profileImage.layer.borderColor = UIColor.white.cgColor
            
            descriptionLabel.text = user.tagline
            followingNumberLabel.text = String(user.followingCount ?? 0)
            followersNumberLabel.text = String(user.followersCount ?? 0)
            tweetsNumberLabel.text = String(user.statusesCount ?? 0)
            
            
            
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
