//
//  LoginViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/25/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    override func viewDidLoad() { 
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        TwitterService.sharedInstance.login(success: {
            
            // Logged in, segue to the next view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let hamburgerViewController = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController // Is the initial view here
            let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuViewController.hamburgerViewController = hamburgerViewController
            hamburgerViewController.menuViewController = menuViewController
            
            self.present(hamburgerViewController, animated: true, completion: nil)
            
            
        }) { (error: Error) in
            print("Error :\(error.localizedDescription)")
        }
        
    }

}
