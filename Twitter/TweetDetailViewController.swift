//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/29/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var replies: [Tweet]! = [Tweet]()
    var tweet: Tweet!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set zero height table footer to not show cells beyond those asked for
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 237.0
        
        
        tableView.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Detail
            return 1
        case 1: // Replies
            return replies.count
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0: // Detail
                let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
                detailCell.tweet = tweet
                return detailCell
            case 1: // Replies
                let replyCell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell") as! ReplyCell
                replyCell.tweet = replies[indexPath.row]
                return replyCell
        default:
            return UITableViewCell()
        }
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
