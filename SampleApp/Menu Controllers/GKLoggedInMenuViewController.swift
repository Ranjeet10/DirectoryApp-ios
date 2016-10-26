//
//  GKLoggedInMenuViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/25/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKLoggedInMenuViewController: UIViewController {
    
    var menuItems = [String]()
    
    var menuItemsDescription = [String]()
    
    let loggedInMenuItems = ["My Profile","Edit Profile", "Sync", "Share", "Rate", "Logout"]
    let loggedInMenuDescription = ["View your details", "Edit your Profile", "Sync Database", "Share with your friends", "Rate app on App Store", "Logout from your account"]
    
    var profileDetails: NSDictionary?
    
    @IBOutlet weak var menuTopView: UIView!
    
    @IBOutlet weak var menuTable: UITableView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var userShortDetails: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let val = self.profileDetails {
            print("Got After Login", val)
        }else {
            self.profileDetails = GKUserDefaults.getValueFromDefaultsForKey(kUserInfo) as? NSDictionary
        }
        
        self.menuItems = loggedInMenuItems
        self.menuItemsDescription = loggedInMenuDescription
        
        let image: UIImage = UIImage.init(named: "menuKartnataka")!
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.menuTopView.frame.size.width, right: self.menuTopView.frame.size.height)
        
        self.menuTopView.backgroundColor = UIColor.init(patternImage: image.imageWithAlignmentRectInsets(edgeInsets))
        
        self.username.text = self.profileDetails?.objectForKey("name") as? String
        self.userShortDetails.text = self.profileDetails?.objectForKey("position") as? String
        self.menuTable.reloadData()
        self.profileImage.contentMode = .ScaleToFill
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        self.profileImage.clipsToBounds = true
        self.profileImage.image = self.getImageFromDocuments()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.profileImage.image = self.getImageFromDocuments()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            cell.imageView?.image = UIImage(named: "editprofile")
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
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let viewMyProfile: GKUserDetailsViewController = storyboard.instantiateViewControllerWithIdentifier("GKUserDetailsViewController") as! GKUserDetailsViewController
            
            viewMyProfile.profileDetails = self.profileDetails
            viewMyProfile.showMyProfile = true
            
            let navVC = UINavigationController(rootViewController: viewMyProfile)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
            
            
        }
        
        
        if indexPath.row == 1 {
            
            let editProfileViewController = storyboard.instantiateViewControllerWithIdentifier("GKEditProfileViewController") as! GKEditProfileViewController
            editProfileViewController.profileDetails = self.profileDetails
            editProfileViewController.showMyProfile = true
            
            let navVC = UINavigationController(rootViewController: editProfileViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
            
        }
        
        if indexPath.row == 2 {
            
            let appdelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            appdelegate.setupRootViewController(true)
            
        }
        
        
        
        if indexPath.row == 3 {
            
            displayShareSheet("link")
            
        }
        
        if indexPath.row == 4 {
            
            let url = NSURL(string: "itms-apps://itunes.com/apps/appname")
            UIApplication.sharedApplication().openURL(url!)

            
        }
        
        if indexPath.row == 5 {
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                let loginViewController = storyboard.instantiateViewControllerWithIdentifier("GKLoginAppViewController") as! GKLoginAppViewController
                let navVC = UINavigationController(rootViewController: loginViewController)
                let preLoggedInLeftMenuViewController = storyboard.instantiateViewControllerWithIdentifier("GKLeftMenuViewController") as! GKLeftMenuViewController
                
                self.slideMenuController()?.changeMainViewController(navVC, close: true)
                self.slideMenuController()?.changeLeftViewController(preLoggedInLeftMenuViewController, closeLeft: true)
                
                GKUserDefaults.setBoolInDefaults(false, forKey: kLoggedIn)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            
        }
        
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
}
