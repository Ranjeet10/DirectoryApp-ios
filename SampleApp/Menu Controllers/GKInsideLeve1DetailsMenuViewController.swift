//
//  GKInsideLeve1DetailsMenuViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/25/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKInsideLeve1DetailsMenuViewController: UIViewController {
    
    var menuItems: [String]?
    
    @IBOutlet weak var menuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showLineNameMenu), name: "lineNameMenu", object: nil)
        self.menuTable.estimatedRowHeight = 100
        self.menuTable.rowHeight = UITableViewAutomaticDimension
        self.menuItems?.insert("Back", atIndex: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLineNameMenu(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        let details = userInfo["lineName"] as! [String]?
        self.menuItems = details!
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.menuTable.reloadData()
        }
        
    }
    
    
    //MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftMenuItemTableViewCell") as! LeftMenuItemTableViewCell
        cell.menuItemTitleLabel.text = menuItems![indexPath.row]
        
        switch indexPath.row {
            
        case 0:
            cell.imageView?.image = UIImage(named: "back")
            break
        case 1:
            cell.imageView?.image = UIImage(named: "mainLine")
            break
        default:
            cell.imageView?.image = UIImage(named: "disclosureAccessory")
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
            
        case 0:
            let notification = NSNotification(name: "PerformSegue", object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
            self.closeLeft()
            break
        default:
            let notification = NSNotification(name: "ChangeInsideLevelContents", object: nil, userInfo: ["lineName" : self.menuItems![indexPath.row]])
            NSNotificationCenter.defaultCenter().postNotification(notification)
            self.closeLeft()
        }
        
    }
    
}
