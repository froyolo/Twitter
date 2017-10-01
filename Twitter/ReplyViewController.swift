//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/30/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var authorScreennameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var remainingCharactersButton: UIBarButtonItem!

    fileprivate var replyHandler: (Tweet) -> Void = { (tweet) in }
    var tweet: Tweet! // Tweet being replied to
    
    func prepare(tweet: Tweet!, replyHandler: @escaping (Tweet) -> Void) {
        if let tweet = tweet {
            self.tweet = tweet
        }
        self.replyHandler = replyHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorScreennameLabel.text = tweet.user.screenname
        
        textView.delegate = self
        
        // Keyboard is always visible and the text view is always the first responder
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyTapped(_ sender: UIBarButtonItem) {
        TwitterService.sharedInstance?.repliedToTweet(tweet: tweet, replyText: textView.text, success: { (tweet: Tweet) in
            self.replyHandler(tweet)
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let viewText = textView.text {
            let newLength = viewText.characters.count + text.characters.count - range.length
            
            let remainingCount = Tweet.characterLimit - newLength
            if remainingCount >= 0 {
                self.remainingCharactersButton.title =  "\(remainingCount)"
            }
            
            return newLength <= Tweet.characterLimit
        }
        return true;
    }
    
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
