//
//  GKLeftMenuViewController.swift
//  sampleDirectoryApp
//
//  Created by Ranjeet Sah on 10/4/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKLeftMenuViewController: UIViewController {
    
    var menuItems = ["Login", "About App", "Sync", "Share", "Rate"]
    
    var menuItemsDescription = ["Login if you are Govt Employee", "Know more about app", "Sync Database", "Share with your friends", "Rate app on App Store"]
    
    var aboutAppViewController: GKAboutAppViewController?
    
    @IBOutlet weak var menuTopView: UIView!
    
    @IBOutlet weak var menuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let image: UIImage = UIImage.init(named: "menuKartnataka")!
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.menuTopView.frame.size.width, right: self.menuTopView.frame.size.height)
        
        self.menuTopView.backgroundColor = UIColor.init(patternImage: image.imageWithAlignmentRectInsets(edgeInsets))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showPostLoginMenu), name: "LoggedInMenu", object: nil)
        
        
            
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showPostLoginMenu() {
        
        self.menuItems = ["My Profile","Edit Profile", "Sync", "Share", "Rate", "Logout"]
        self.menuItemsDescription = ["View your details", "Edit your Profile", "Sync Database", "Share with your friends", "Rate app on App Store", "Logout from your account"]
        self.menuTable.reloadData()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftMenuItemTableViewCell") as! LeftMenuItemTableViewCell
        cell.menuItemTitleLabel.text = menuItems[indexPath.row]
        cell.menuItemDescription.text = menuItemsDescription[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if indexPath.row == 1 {
            
            let aboutAppViewController = storyboard.instantiateViewControllerWithIdentifier("GKAboutAppViewController") as! GKAboutAppViewController
            
            let navVC = UINavigationController(rootViewController: aboutAppViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
            
            
        }
        
        if indexPath.row == 0 {
            
            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("GKLoginViewController") as! GKLoginViewController
            
            let navVC = UINavigationController(rootViewController: loginViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
            
            
        }
        
        if indexPath.row == 5 {
            
            self.menuItems = ["Login", "About App", "Sync", "Share", "Rate"]
            self.menuItemsDescription = ["Login if you are Govt Employee", "Know more about app", "Sync Database", "Share with your friends", "Rate app on App Store"]
            self.menuTable.reloadData()
            let mainViewController = storyboard.instantiateViewControllerWithIdentifier("GKMainViewController") as! GKMainViewController
            let navVC = UINavigationController(rootViewController: mainViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
            
        }
        
    }
    
}
