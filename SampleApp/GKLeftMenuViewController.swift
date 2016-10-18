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
    
    var loggedIn = false
    
    var profileDetails: NSDictionary?
        
    @IBOutlet weak var menuTopView: UIView!
    
    @IBOutlet weak var menuTable: UITableView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var userShortDetails: UILabel!
    
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
    
    
    func showPostLoginMenu(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        let details = userInfo["userDetails"] as! NSDictionary?
        self.profileDetails = details
        
        self.menuItems = ["My Profile","Edit Profile", "Sync", "Share", "Rate", "Logout"]
        self.menuItemsDescription = ["View your details", "Edit your Profile", "Sync Database", "Share with your friends", "Rate app on App Store", "Logout from your account"]
       self.loggedIn = true
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.username.text = self.profileDetails?.objectForKey("name") as? String
            self.userShortDetails.text = self.profileDetails?.objectForKey("position") as? String
             self.menuTable.reloadData()
        }
        
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
        
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(named: "profile")
            break
        case 1:
            if self.loggedIn {
                cell.imageView?.image = UIImage(named: "editprofile")
            }else{
              cell.imageView?.image = UIImage(named: "about_app")
            }
            break
        case 2:
            cell.imageView?.image = UIImage(named: "logout")
            break
        case 3:
            cell.imageView?.image = UIImage(named: "share")
            break
        case 4:
            cell.imageView?.image = UIImage(named: "rate")
            break
        case 5:
            cell.imageView?.image = UIImage(named: "logout")
            break
        default:
            break
        }
 
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if indexPath.row == 0 {
            
            if self.loggedIn {
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                
                let viewMyProfile: GKUserDetailsViewController = storyboard.instantiateViewControllerWithIdentifier("GKUserDetailsViewController") as! GKUserDetailsViewController
                
                viewMyProfile.profileDetails = self.profileDetails
                viewMyProfile.showMyProfile = true
                
                let navVC = UINavigationController(rootViewController: viewMyProfile)
                self.slideMenuController()?.changeMainViewController(navVC, close: true)
                
                
            }else {
                self.checkDefaultsAndShowRespectivePage()
            }
            
            
        }
        
        
        if indexPath.row == 1 {
            
           if self.loggedIn {
            
            let editProfileViewController = storyboard.instantiateViewControllerWithIdentifier("GKEditProfileViewController") as! GKEditProfileViewController
            editProfileViewController.profileDetails = self.profileDetails
            editProfileViewController.showMyProfile = true
            
            let navVC = UINavigationController(rootViewController: editProfileViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
            
            
           }
            
           else {
            
            
            let aboutAppViewController = storyboard.instantiateViewControllerWithIdentifier("GKAboutAppViewController") as! GKAboutAppViewController
            
            let navVC = UINavigationController(rootViewController: aboutAppViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
            
            }
            
            
        }
        
        
        
        
        
        if indexPath.row == 3 {
            
            displayShareSheet("link")
            
        }
        
        if indexPath.row == 5 {
            
            self.menuItems = ["Login", "About App", "Sync", "Share", "Rate"]
            self.menuItemsDescription = ["Login if you are Govt Employee", "Know more about app", "Sync Database", "Share with your friends", "Rate app on App Store"]
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.username.text = "Guest"
                self.userShortDetails.text = "Login if you are a gov employee"
                self.menuTable.reloadData()
            }
            self.loggedIn = false
            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("GKLoginAppViewController") as! GKLoginAppViewController
            let navVC = UINavigationController(rootViewController: loginViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
            
        }
        
    }
    
    func checkDefaultsAndShowRespectivePage() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if !defaults.boolForKey("hasLoggedInSecond") {
            defaults.setBool(false, forKey: "hasLoggedInSecond")
        }
        
        if defaults.boolForKey("hasLoggedInSecond") {
            
            let loginAppViewController = storyboard!.instantiateViewControllerWithIdentifier("GKLoginAppViewController") as! GKLoginAppViewController
            
            let navVC = UINavigationController(rootViewController: loginAppViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
        }
        else {
            
            let loginViewController = storyboard!.instantiateViewControllerWithIdentifier("GKLoginViewController") as! GKLoginViewController
            
            let navVC = UINavigationController(rootViewController: loginViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
        }
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
   
}
