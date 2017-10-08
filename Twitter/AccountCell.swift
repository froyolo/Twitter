//
//  AccountCell.swift
//  Twitter
//
//  Created by Ngan, Naomi on 10/7/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isDefaultImage: UIImageView!
    
    
    var user: User! {
        didSet {
            if user.screenname != User.currentUser?.screenname {
                isDefaultImage.isHidden = true
            }
            
            screennameLabel.text = user.screenname!
            nameLabel.text = user.name!
            profileImage.setImageWith(user.profileUrl!)
            profileImage.layer.borderWidth = 3
            profileImage.layer.borderColor = UIColor.white.cgColor
            
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
