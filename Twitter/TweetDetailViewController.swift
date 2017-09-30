//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/29/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    let favoritedImage = UIImage(named: "hearted")
    let unfavoritedImage = UIImage(named: "unhearted")

    var tweet: Tweet! {
        didSet{
            // Only update labels if the outlets exist
            if nameLabel != nil && profileImage != nil && screennameLabel != nil && timestampLabel != nil && tweetTextLabel != nil {
                updateLabels()
            }
        }
    }
    

    @IBAction func favoriteTapped(_ sender: UIButton) {
        TwitterService.sharedInstance?.favoritedTweet(id: tweet.id!, success: { () in
            self.favoriteButton.setBackgroundImage(self.favoritedImage, for: UIControlState.normal)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    
    func updateLabels() {
        screennameLabel.text = tweet.user?.screenname
        nameLabel.text = tweet.user?.name
        tweetTextLabel.text = tweet.text
        timestampLabel.text = tweet.timestamp?.toString()
        
        if let profileImageURL = tweet.user?.profileUrl {
            profileImage.setImageWith(profileImageURL)
        }
        
        if tweet.favorited {
            self.favoriteButton.setBackgroundImage(favoritedImage, for: UIControlState.normal)
        } else {
            self.favoriteButton.setBackgroundImage(unfavoritedImage, for: UIControlState.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
