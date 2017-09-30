//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/29/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    fileprivate var tweetHandler: () -> Void = { () in }
    
    var user: User! {
        didSet{
            // Only update labels if the outlets exist
            if nameLabel != nil && profileImage != nil && screennameLabel != nil {
                updateLabels()
            }
        }
    }
    
    func prepare(user: User!, tweetHandler: @escaping () -> Void) {
        if let user = user {
            self.user = user
        }
        self.tweetHandler = tweetHandler
    }
    
    @IBAction func tweetTapped(_ sender: UIBarButtonItem) {
        TwitterService.sharedInstance?.postTweet(status: textView.text, success: { (tweet: Tweet) in
            self.tweetHandler()
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        textView.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func updateLabels() {
        screennameLabel.text = user.screenname
        nameLabel.text = user.name
        if let profileImageURL = user.profileUrl {
            profileImage.setImageWith(profileImageURL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Keyboard is always visible and the text view is always the first responder
        textView.becomeFirstResponder()
        
        updateLabels()
        
        // Do any additional setup after loading the view.
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
