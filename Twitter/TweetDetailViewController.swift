//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/29/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    let favoritedImage = UIImage(named: "hearted")
    let unfavoritedImage = UIImage(named: "unhearted")
    let retweetedImage = UIImage(named: "retweet")
    let unretweetedImage = UIImage(named: "unretweet")
    var replies: [Tweet]! = [Tweet]()

    
    var tweet: Tweet! {
        didSet{
            // Only update labels if the outlets exist
            if nameLabel != nil && profileImage != nil && screennameLabel != nil && timestampLabel != nil && tweetTextLabel != nil {
                updateLabels()
            }
        }
    }
    
    @IBAction func retweetTapped(_ sender: UIButton) {
        TwitterService.sharedInstance?.retweet(tweet: tweet, success: { (tweet) in
            self.retweetButton.setImage(self.retweetedImage, for: UIControlState.normal)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
        TwitterService.sharedInstance?.favoritedTweet(id: tweet.id!, success: { () in
            self.favoriteButton.setImage(self.favoritedImage, for: UIControlState.normal)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    
    func updateLabels() {
        
        screennameLabel.text = tweet.user?.screenname
        nameLabel.text = tweet.user?.name
        tweetTextLabel.text = tweet.text
        timestampLabel.text = tweet.timestamp?.toString()
        favoriteCountLabel.text = "\(tweet.favoritesCount)"
        tweetCountLabel.text = "\(tweet.retweetCount)"
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set zero height table footer to not show cells beyond those asked for
        tableView.tableFooterView = UIView()
        updateLabels()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell") as! ReplyCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replyTo" {
            let replyNav = segue.destination as! UINavigationController
            let replyViewController = replyNav.viewControllers.first as! ReplyViewController
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            replyViewController.tweet = tweet
            replyViewController.prepare(tweet: tweet, replyHandler: { (tweet) in
                self.replies.append(tweet)
                self.tableView.reloadData()
            })
        }
    }

}
