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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        // Consider putting in user class to fully hide API from VC level
        TwitterService.sharedInstance.login(success: {
            
            // Logged in, segue to the next view controller
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
        }) { (error: Error) in
            print("Error :\(error.localizedDescription)")
        }
        
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
