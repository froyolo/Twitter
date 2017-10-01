//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/26/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]! = [Tweet]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterService.sharedInstance?.logout()
        
        // In v2, he does User.currentUser?.logout()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self

        // Pull to refresh initialization/binding
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Load home timeline
        self.getHomeTimelines()
        
    }
    
    // Perform the search.
    fileprivate func getHomeTimelines() {
        
        TwitterService.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest `myRequest` ...
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.getHomeTimelines()
            refreshControl.endRefreshing()
        }
        task.resume()
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController = segue.destination as! TweetDetailViewController
            var indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let tweet = tweets[indexPath.row]
            detailViewController.tweet = tweet
        
            let backItem = UIBarButtonItem()
            backItem.title = "Home"
            navigationItem.backBarButtonItem = backItem
        } else if segue.identifier == "composeNew" {
            let composeNav = segue.destination as! UINavigationController
            let composeViewController = composeNav.viewControllers.first as! ComposeViewController
            
            composeViewController.prepare(tweetHandler: { (tweet) in
                // Avoid refetching the timeline.  Just tack the new tweet to the beginning.
                self.tweets.insert(tweet, at: 0)
                self.tableView.reloadData()
            })
        }
    }

}
