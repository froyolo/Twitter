//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/30/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard is always visible and the text view is always the first responder
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
