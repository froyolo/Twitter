//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 10/5/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var user: User! = User.currentUser
    var tweets: [Tweet]! = [Tweet]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        getUserTimelines()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }

    fileprivate func getUserTimelines() {
        TwitterService.sharedInstance?.userTimeline(user: user, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return tweets.count
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Profile Detail
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            profileCell.user = user
            return profileCell
        case 1: // Tweets
            let tweetCell = Bundle.main.loadNibNamed("TweetCell", owner: self, options: nil)?.first as! TweetCell
            tweetCell.tweet = tweets[indexPath.row]
            tweetCell.tweet.user = user
            return tweetCell
        default:
            return UITableViewCell()
        }
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController = segue.destination as! TweetDetailViewController
            var indexPath = sender as! IndexPath
            let tweet = tweets[indexPath.row]
            detailViewController.tweet = tweet
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
         }
    }
    
    
    
//    fileprivate func getProfileInfo() {
//        TwitterService.currentU
//        TwitterService.sharedInstance?.showUser(success: { (user: User) in
//            code
//        }, failure: { (error: Error) in
//            <#code#>
//        })
//        
//        TwitterService.sharedInstance?.homeTimeline(maxId: maxId, success: { (tweets: [Tweet]) in
//            self.tweets = tweets
//            
//            // Update flag
//            self.isMoreDataLoading = false
//            
//            // Stop the loading indicator
//            self.loadingMoreView!.stopAnimating()
//            
//            self.tableView.reloadData()
//            
//        }, failure: { (error: Error) in
//            print(error.localizedDescription)
//        })
//        
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
