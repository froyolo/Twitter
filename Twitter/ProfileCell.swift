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
    @IBOutlet weak var scrollView: UIScrollView!
    
    
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
            followingNumberLabel.text = user.followingCount?.abbreviated
            followersNumberLabel.text = user.followersCount?.abbreviated
            tweetsNumberLabel.text = user.statusesCount?.abbreviated
            
            
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
        /*
//        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 12,
                                            scrollView.frame.size.height);
        scrollView.pagingEnabled=YES;
        scrollView.backgroundColor = [UIColor blackColor];
        
        // Generate content for our scroll view using the frame height and width as the reference point
        
        int i = 0;
        while (i<=11) {
            
            UIView *views = [[UIView alloc]
                initWithFrame:CGRectMake(((scrollView.frame.size.width)*i)+20, 10,
                (scrollView.frame.size.width)-40, scrollView.frame.size.height-20)];
            views.backgroundColor=[UIColor yellowColor];
            [views setTag:i];
            [scrollView addSubview:views];
            
            i++;
        }*/
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
