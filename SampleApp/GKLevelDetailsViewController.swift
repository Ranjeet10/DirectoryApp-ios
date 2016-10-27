//
//  GKLevelDetailsViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/6/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKLevelDetailsViewController: UIViewController, HTTPClientDelegate {
    
    var insideLevel1Details: NSArray = NSArray()
    var level1Titile: String?
    var departmentName: String?
    var showInsideLevel1: Bool?
    var insideLevelDetails: NSDictionary?
    var lineNameArray = [String]()
    var newInsideLevelDetailsAsPerLineNumber = NSMutableArray()
    var titleText: String?
    var label: UILabel?
    
    @IBOutlet weak var insideLevel1DetailsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.titleText = self.level1Titile
        
        self.label =  UILabel(frame: CGRect(x: 0, y: 0, width: 480, height: 44))
        self.label!.backgroundColor = UIColor.clearColor()
        self.label!.numberOfLines = 0
        self.label!.font = UIFont.boldSystemFontOfSize(15.0)
        self.label!.textColor = UIColor.whiteColor()
        self.setNavigationTitle(self.titleText!)
    
        self.insideLevel1Details = insideLevelDetails!["data"] as! NSArray
        
        if showInsideLevel1! {
            self.customizeNavigationBar()
            self.getLineName()
            self.showFirstLineOnly()
           
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.createArrayAccorddingToLineNumber(_:)), name: GKConstants.sharedInstanse.kChangeInsideLevelContents, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.performUnwindToMain), name: GKConstants.sharedInstanse.kShowMainPageNotification, object: nil)
            
        }
        else{
            self.insideLevel1DetailsTable.reloadData()
        }
        self.insideLevel1DetailsTable.estimatedRowHeight = 100
        self.insideLevel1DetailsTable.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insideLevel1Details.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InsideLevel1TableViewCell") as! InsideLevel1TableViewCell
        let individualInsideLevel1Detail = insideLevel1Details[indexPath.row] as! NSDictionary
        
        cell.insideLevel1Position.text = individualInsideLevel1Detail.objectForKey("position") as? String
        cell.insideLevel1Name.text = individualInsideLevel1Detail.objectForKey("name") as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showUserDetails", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserDetails" {
            let userDetailsVC:GKUserDetailsViewController = segue.destinationViewController as! GKUserDetailsViewController
            
            userDetailsVC.insideLevel1Details = self.insideLevel1Details
            userDetailsVC.selectedIndex = self.insideLevel1DetailsTable.indexPathForSelectedRow?.row
            userDetailsVC.showMyProfile = false
            self.getBacKButton()
        }
        
    }
    
    func getLineName() {
        if showInsideLevel1! {
            for individualInsideLevel1Detail in self.insideLevel1Details {
               let lineName = individualInsideLevel1Detail.objectForKey("lineName") as! String
                if !self.lineNameArray.contains(lineName) {
                    self.lineNameArray.append(lineName)
                }
            }
            self.changeLeftMenu()
        }
        print(self.lineNameArray.count)
    }
    
    func changeLeftMenu() {
        
        let insideLevel1DetailsMenuController = GKConstants.sharedInstanse.dynamicMenuStoryBoard.instantiateViewControllerWithIdentifier("GKInsideLeve1DetailsMenuViewController") as! GKInsideLeve1DetailsMenuViewController
        insideLevel1DetailsMenuController.menuItems = self.lineNameArray
        
        self.slideMenuController()?.changeLeftViewController(insideLevel1DetailsMenuController, closeLeft: true)
        
    }
    
    func createArrayAccorddingToLineNumber(notification: NSNotification) {
        
        self.newInsideLevelDetailsAsPerLineNumber = NSMutableArray()
        let userInfo = notification.userInfo as! [String: AnyObject]
        let lineName = userInfo["lineName"] as! String
        self.setNavigationTitle(lineName)
            for individualInsideLevel1Detail in insideLevelDetails!["data"] as! NSArray {
                let lineNameToCompare = individualInsideLevel1Detail.objectForKey("lineName") as! String
                if lineName == lineNameToCompare {
                    self.newInsideLevelDetailsAsPerLineNumber.addObject(individualInsideLevel1Detail)
                }
            }
        self.insideLevel1Details = self.newInsideLevelDetailsAsPerLineNumber
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.insideLevel1DetailsTable.reloadData()
            self.insideLevel1DetailsTable.scrollsToTop = true
        }
    }
    
    func setNavigationTitle(titleText: String) {
        
        self.label!.text = titleText
        self.navigationItem.titleView = label

    }
    
    func showFirstLineOnly() {
        
        self.newInsideLevelDetailsAsPerLineNumber = NSMutableArray()
        let lineName = self.lineNameArray.first
        for individualInsideLevel1Detail in self.insideLevel1Details {
            let lineNameToCompare = individualInsideLevel1Detail.objectForKey("lineName") as! String
            if lineName == lineNameToCompare {
                self.newInsideLevelDetailsAsPerLineNumber.addObject(individualInsideLevel1Detail)
            }
        }
        self.insideLevel1Details = self.newInsideLevelDetailsAsPerLineNumber
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.insideLevel1DetailsTable.reloadData()
        }
        
    }
    
    @IBAction func showRespectiveMenuOnNavingatingOutOfInsideLevelDetails() {
        
        if let loggedIn = GKUserDefaults.getValueFromDefaultsForKey(kLoggedIn) as? Bool{
            
            if loggedIn {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.popView()
                    self.showLoggedInMenu()
                }
            }else {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.popView()
                    self.showLoggedOutMenu()
                }
            }
            
           
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func performUnwindToMain() {
                
        let loggedIn = GKUserDefaults.getBoolFromDefaultsForKey(kLoggedIn)
        
        if loggedIn {
            self.showLoggedInMenu()

        }else{
            self.showLoggedOutMenu()

        }
        self.performSegueWithIdentifier("goBackToMain", sender: self)

    }

    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
