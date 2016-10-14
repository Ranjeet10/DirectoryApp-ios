//
//  GKLevelDetailsViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/6/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKLevelDetailsViewController: UIViewController {
    
    var insideLevel1Details: NSArray = NSArray()
    var level1Titile: String?
    var departmentName: String?
    var showInsideLevel1: Bool?
    
    @IBOutlet weak var insideLevel1DetailsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.level1Titile
        
        if showInsideLevel1! {
            self.customizeNavigationBar()
        }
        else{
            self.customizeDetailViewsNavigationBar()
        }
        
      //  LibraryAPI.sharedInstance.downloadInsideData()
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(populateTable(_:)), name: "GKInsideDetails", object: nil)

        
        self.getInsideLevel1Data(self.departmentName!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateTable(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        let details = userInfo["InsideDetails"] as! NSDictionary?
//        self.level1Details = details!["level1"] as! NSArray
//        self.level1TableView.reloadData()
        
        print(details)
        
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
        }
    }
    
    
    func getInsideLevel1Data(department: String) {
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/getleveldata.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr:String = "level1=".stringByAppendingString(department)
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Your completion handler code here
            
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET request")
                print(error)
                return
            }
            
            do {
                guard let resultDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? NSDictionary else {
                    
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                print("The result is: " + resultDict.description)
                if resultDict["error"] as! Bool == false {
                    self.insideLevel1Details = resultDict["data"] as! NSArray
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.insideLevel1DetailsTable.reloadData()
                    }
                    
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
            
        }
        task.resume()
        
    }

}
