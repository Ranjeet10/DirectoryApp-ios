//
//  GKLeftMenuViewController.swift
//  sampleDirectoryApp
//
//  Created by Ranjeet Sah on 10/4/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKLeftMenuViewController: UIViewController {
    
    let menuItems = ["Login", "About App", "Sync", "Share", "Rate"]
    let menuItemsDescription = ["Login if you are Govt Employee", "Know more about app", "Sync Database", "Share with your friends", "Rate app on Google Play"]
    var aboutAppViewController: GKAboutAppViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
    }
    
}
