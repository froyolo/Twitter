//
//  MenuViewController.swift
//  Twitter
//
//  Created by Ngan, Naomi on 10/5/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    private var profileNavigationController: UIViewController!
    private var timelineNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    private var accountsNavigationController: UIViewController!

    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        accountsNavigationController = storyboard.instantiateViewController(withIdentifier: "AccountsNavigationController")
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionsNavigationController)
        viewControllers.append(accountsNavigationController)
        
        hamburgerViewController.contentViewController = timelineNavigationController
        
        // Set zero height table footer to not show cells beyond those asked for
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Set content view of the hamburger VC
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let titles = ["Profile", "Timeline", "Mentions", "Accounts"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
