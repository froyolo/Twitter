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
    
    var tweet: Tweet! {
        didSet{
            // Only update labels if the outlets exist
            if nameLabel != nil && profileImage != nil && screennameLabel != nil && timestampLabel != nil && tweetTextLabel != nil {
                updateLabels()
            }
        }
    }
    
    func updateLabels() {
        screennameLabel.text = tweet.user?.screenname
        nameLabel.text = tweet.user?.name
        tweetTextLabel.text = tweet.text
        timestampLabel.text = tweet.timestamp?.toString()
        
        if let profileImageURL = tweet.user?.profileUrl {
            profileImage.setImageWith(profileImageURL)
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
