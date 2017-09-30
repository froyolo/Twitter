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
        
        // Can't set return type because it takes time to fetch from server.  Must be done asynchronously
        TwitterService.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
         }, failure: { (error: Error) in
            print(error.localizedDescription)
         })
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
 let vc = segue.destination as! PhotoDetailsViewController // Gets a reference to the PhotoDetailsViewController
 let indexPath = tableView.indexPath(for: sender as! UITableViewCell)! // Gets the indexPath of the selected photo
 let post = posts[indexPath.row] // Grab post at row indexPath
 if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] { // Grab the “photos” key
 vc.photoUrl = photos[0].value(forKeyPath: "original_size.url") as? String // Set the photo property
*/

 
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! TweetDetailViewController
        var indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let tweet = tweets[indexPath.row]
        detailViewController.tweet = tweet

        
    }

}
