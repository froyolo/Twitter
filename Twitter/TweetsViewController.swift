//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/26/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false // infinite scrolling
    var loadingMoreView:InfiniteScrollActivityView?
    var tweets: [Tweet]! = [Tweet]()
    var resultsLimit = 20
    var offset = 0
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterService.sharedInstance?.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self

        // Pull to refresh initialization/binding
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

        // Load home timeline
        getHomeTimelines()
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
    }
    
    // For infinite scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Load more results ...
                getHomeTimelines()
            }
            
            
        }
    }
    
    
    // Perform the search.
    fileprivate func getHomeTimelines() {
        // Not getting more data, so we reset to make sure we don't append
        var maxId: String?
        if isMoreDataLoading && tweets.count > 0 {
            maxId = (tweets[tweets.count-1]).id!
        }
        
        TwitterService.sharedInstance?.homeTimeline(maxId: maxId, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()

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
    }
 
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
