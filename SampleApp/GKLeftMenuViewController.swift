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
    
    @IBOutlet weak var menuTopView: UIView!
    
    @IBOutlet weak var menuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let image: UIImage = UIImage.init(named: "menuKartnataka")!
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.menuTopView.frame.size.width, right: self.menuTopView.frame.size.height)
        
        self.menuTopView.backgroundColor = UIColor.init(patternImage: image.imageWithAlignmentRectInsets(edgeInsets))
        
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
            cell.imageView?.image = UIImage(named: "about_app")
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
        default:
            break
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            
            self.checkDefaultsAndShowRespectivePage()
            
        }
        
        
        if indexPath.row == 1 {
            
            let aboutAppViewController = GKConstants.sharedInstanse.storyboard.instantiateViewControllerWithIdentifier("GKAboutAppViewController") as! GKAboutAppViewController
            
            let navVC = UINavigationController(rootViewController: aboutAppViewController)
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
        
    }
    
    func checkDefaultsAndShowRespectivePage() {
        
        if let val = GKUserDefaults.getValueFromDefaultsForKey(kSecondLogIn) as? Bool {
            if !val {
                GKUserDefaults.setBoolInDefaults(false, forKey: kSecondLogIn)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
        
        if GKUserDefaults.getBoolFromDefaultsForKey(kSecondLogIn) {
            
            let loginAppViewController = GKConstants.sharedInstanse.storyboard.instantiateViewControllerWithIdentifier("GKLoginAppViewController") as! GKLoginAppViewController
            
            let navVC = UINavigationController(rootViewController: loginAppViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
        }
        else {
            
            let loginViewController = GKConstants.sharedInstanse.storyboard.instantiateViewControllerWithIdentifier("GKLoginViewController") as! GKLoginViewController
            
            let navVC = UINavigationController(rootViewController: loginViewController)
            self.slideMenuController()?.changeMainViewController(navVC, close: true)
        }
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
}
