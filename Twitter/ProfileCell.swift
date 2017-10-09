//
//  ProfileCell.swift
//  Twitter
//
//  Created by Ngan, Naomi on 10/5/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell, UIScrollViewDelegate {

    
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
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    

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
    
    @IBAction func onPageChange(_ sender: UIPageControl) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Add in opacity changes as paging happens
        var percent = 1 - (scrollView.contentOffset.x / scrollView.frame.size.width);
        percent = percent < 0.2 ? 0.2 : percent
        posterImage.alpha = percent;
        
        // Make sure page control changes
        let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self

        // Configure page control
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
        scrollView.isPagingEnabled = true
        
        // Position of views for paging
        
        contentView.layoutIfNeeded()
        infoView.frame.origin.x = 0
        infoView.frame.origin.y = 0
        descriptionView.frame.origin.x = scrollView.frame.size.width
        descriptionView.frame.origin.y = 0

        
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
        
        /*
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = scrollView.bounds
        addSubview(effectView)*/

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
