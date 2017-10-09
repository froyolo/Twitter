//
//  AccountsViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 10/5/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var accountIndices: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        // Set zero height table footer to not show cells beyond those asked for
        tableView.tableFooterView = UIView()
        
        accountIndices = User.accounts.keys.sorted()

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = User.accounts[accountIndices[indexPath.row]]
            if let user = user {
                user.delete()
                accountIndices.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Log out"
    }
    
    @IBAction func onDoneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddAccountTapped(_ sender: UIBarButtonItem) {
        TwitterService.sharedInstance.logout()
        TwitterService.sharedInstance.login(forcedLogin: true, success: {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        User.currentUser = User.accounts[accountIndices[indexPath.row]]
        
        
        DispatchQueue.main.async {
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountIndices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let accountCell = tableView.dequeueReusableCell(withIdentifier: "AccountCell") as! AccountCell
        accountCell.user = User.accounts[accountIndices[indexPath.row]]
        return accountCell
    }

}
