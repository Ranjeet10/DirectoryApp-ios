//
//  MainViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/5/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKMainViewController: UIViewController, GKSlideMenuControllerDelegate, HTTPClientDelegate{

    var level1Details: NSArray = NSArray()
    var insideLevel1Details: NSArray = NSArray()
    @IBOutlet weak var level1TableView: UITableView!
    var showInsideLevel1 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Directory"
        self.customizeNavigationBar()
        self.level1TableView.estimatedRowHeight = 50
        self.level1TableView.rowHeight = UITableViewAutomaticDimension
        
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(populateTable(_:)), name: "GKDetails", object: nil)
      //  self.downloadData()
        
        self.getLevel1DataHelper()
        
      //  self.getLevel1Details()
        
        self.customizeNavigationBar()
        
        self.level1TableView.estimatedRowHeight = 50

        self.level1TableView.rowHeight = UITableViewAutomaticDimension
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateTable(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        let details = userInfo["details"] as! NSDictionary?
        self.level1Details = details!["level1"] as! NSArray
        self.level1TableView.reloadData()
        
    }

    
    //MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.level1Details.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Level1TableViewCell") as! Level1TableViewCell
        
        let individualLevel1Detail = level1Details[indexPath.row] as! NSDictionary
        
        cell.level1titleLabel.text = individualLevel1Detail.objectForKey("level1") as? String
        
        let accessoryIndicatorNumberAsString = individualLevel1Detail.objectForKey("num") as! String
        
        let accessoryIndicatorNumber:Int? = Int(accessoryIndicatorNumberAsString)
                
        if accessoryIndicatorNumber > 1 {
        
           // cell.accessoryView = self.showCorrectAccesoryView("insideLevelAccessory")
            cell.level1Image.image = UIImage(named: "insideLevelAccessory")
        }
        else {
          //  cell.accessoryView = self.showCorrectAccesoryView("disclosureAccessory")
            cell.level1Image.image = UIImage(named: "disclosureAccessory")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let individualLevel1Detail = level1Details[indexPath.row] as! NSDictionary
        
        let accessoryIndicatorNumberAsString = individualLevel1Detail.objectForKey("num") as! String
        
        let accessoryIndicatorNumber:Int? = Int(accessoryIndicatorNumberAsString)
        
        if accessoryIndicatorNumber > 1 {
            self.showInsideLevel1 = true
        }
        else {
            self.showInsideLevel1 = false
        }
        
        self.performSegueWithIdentifier("showLevelData", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showLevelData") {
            
            let levelDetailsVC:GKLevelDetailsViewController = segue.destinationViewController as! GKLevelDetailsViewController
            let selectedLevel1Detail = level1Details[(level1TableView.indexPathForSelectedRow?.row)!] as! NSDictionary
            let departmentNumber = selectedLevel1Detail.objectForKey("tableID") as! String
            
            levelDetailsVC
                .level1Titile = selectedLevel1Detail.objectForKey("level1") as? String
            levelDetailsVC
                .showInsideLevel1 = self.showInsideLevel1
            levelDetailsVC
                .departmentName = departmentNumber
            
        }
        
        if (segue.identifier == "showInsideLevel1Data") {
            
            let insidelevel1DetailsVC:GKInsideLevel1DetailsViewController = segue.destinationViewController as! GKInsideLevel1DetailsViewController
            
            insidelevel1DetailsVC.insideLevel1Details = self.insideLevel1Details
            
        }
    }
    
    func getLevel1DataHelper() {
        
        let url = "http://directory.karnataka.gov.in/getlevel1.php"
        let level1DataAPIHelper = HTTPClient()
        level1DataAPIHelper.delegate = self
        level1DataAPIHelper.postRequest(url, body: "")
        
    }
    
    func didPerformPOSTRequestSuccessfully(resultDict: AnyObject, resultStatus: Bool) {
        
        
        let responseFromServerDict = resultDict as! NSDictionary
        
        print("The result is: " + responseFromServerDict.description)
        
        if responseFromServerDict["error"] as! Bool == false {
            self.level1Details = resultDict["level1"] as! NSArray
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.level1TableView.reloadData()
            }
            
        }
        
    }
    
    func didFailWithPOSTRequestError(resultStatus: Bool) {
        print("Error")
        self.showAlertWithMessage("Somethig went wrong")
    }
    
    func showCorrectAccesoryView(imageName: String) -> UIButton {
       
        let image: UIImage = UIImage.init(named: imageName)!
        let button: UIButton = UIButton.init(type: .Custom)
        let frame: CGRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height)
        button.frame = frame
        button.setBackgroundImage(image, forState: .Normal)
        return button
    }

}
