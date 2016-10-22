//
//  MainViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/5/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKMainViewController: UIViewController, GKSlideMenuControllerDelegate, HTTPClientDelegate {
        
    var count: Int = 0 {
        willSet(count) {
            print("About to set")
        }
        didSet {
            print("done")
            self.update()
        }
    }
    
    @IBOutlet weak var level1TableView: UITableView!
    
    var level1Details: NSArray = NSArray()
    var insideLevel1Details: NSArray = NSArray()
    var showInsideLevel1 = false
    var tableIDArray = NSMutableArray()
    var resultantDict: NSDictionary?
    var body: String?
    var mainResponseFinished = false
    var alertShown = false
    var departmentName: String?
    var syncDataFlag: Bool?
    var progressVC: GKProgressViewController?
  //  var count = 0
    var totalCount: Int?
    var progressViewShowing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        self.title = "Directory"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.customizeNavigationBar()
        self.level1TableView.estimatedRowHeight = 50
        self.level1TableView.rowHeight = UITableViewAutomaticDimension
        
        if let syncDataFlag = self.syncDataFlag {
            print(syncDataFlag)
        }else {
            self.syncDataFlag = false
        }
        
        self.getLevel1DataHelper()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.getLevel1DetailsDataHelper("level1=".stringByAppendingString(departmentNumber))
            levelDetailsVC.insideLevelDetails = self.resultantDict
            
        }
        
        if (segue.identifier == "showInsideLevel1Data") {
            
            let insidelevel1DetailsVC:GKInsideLevel1DetailsViewController = segue.destinationViewController as! GKInsideLevel1DetailsViewController
            
            insidelevel1DetailsVC.insideLevel1Details = self.insideLevel1Details
            
        }
    }
    
    func getLevel1DataHelper() {
        
        self.body = "level1Details"
        if !syncDataFlag! {
            
            let dataFromDocument = self.getDataFromDocuments(self.body!)
            
            if dataFromDocument.count == 0 {
                
              
                
                let url = "http://directory.karnataka.gov.in/getlevel1.php"
                let level1DataAPIHelper = HTTPClient()
                level1DataAPIHelper.delegate = self
                level1DataAPIHelper.postRequest(url, body: self.body!)
                
            }else{
                
                self.level1Details = dataFromDocument["level1"] as! NSArray
                self.mainResponseFinished = true
                let departmentsArray = self.getListOfDepartments(self.level1Details)
                for department in departmentsArray {
                    self.body = "level1=".stringByAppendingString(department as! String)
                    self.getLevel1DetailsDataHelper(self.body!)
                }
            }
        }
        else {
            
           
            
            let url = "http://directory.karnataka.gov.in/getlevel1.php"
            let level1DataAPIHelper = HTTPClient()
            level1DataAPIHelper.delegate = self
            level1DataAPIHelper.postRequest(url, body: self.body!)
        }
        
    }
    
    func getLevel1DetailsDataHelper(body: String) {
        
        let url = "http://directory.karnataka.gov.in/getleveldata.php"
        
        if !syncDataFlag! {
            
            let dataFromDocument = self.getDataFromDocuments(body)
            
            if dataFromDocument.count == 0 {
                
                let level1DataAPIHelper = HTTPClient()
                level1DataAPIHelper.delegate = self
                level1DataAPIHelper.postRequest(url, body: body)
                
            }else{
                
                self.resultantDict = dataFromDocument
            }
        }
        else{
            
            let level1DataAPIHelper = HTTPClient()
            level1DataAPIHelper.delegate = self
            level1DataAPIHelper.postRequest(url, body: body)
        }
        
    }
    
    func didPerformPOSTRequestSuccessfully(resultDict: AnyObject, resultStatus: Bool, url: String, body: String) {
        
        self.count += 1
        let responseFromServerDict = resultDict as! NSDictionary
        
        if responseFromServerDict["error"] as! Bool == false {
            
            if !self.mainResponseFinished {
                
                
                self.saveDataToDocuments(responseFromServerDict, filename: body)
                self.level1Details = resultDict["level1"] as! NSArray
                let departmentsArray = self.getListOfDepartments(self.level1Details)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if !self.progressViewShowing {
                        self.showProgress(self.count, totalCount: self.totalCount!)
                        self.progressViewShowing = true
                    }
                    self.level1TableView.reloadData()
                }
                self.mainResponseFinished = true
                
                for department in departmentsArray {
                    self.body = "level1=".stringByAppendingString(department as! String)
                    self.getLevel1DetailsDataHelper(self.body!)
                }
            }else{
                self.saveDataToDocuments(responseFromServerDict, filename: body)
                self.resultantDict = responseFromServerDict
            }
            
        }
        print("\n RK", count)
        if count == self.totalCount {
            self.removeProgressBar()
        }
    }
    
    func didFailWithPOSTRequestError(resultStatus: Bool) {
        print("Error")
        if !self.alertShown {
            self.showAlertWithMessage("Somethig went wrong")
            self.alertShown = true
        }
    }
    
    func showCorrectAccesoryView(imageName: String) -> UIButton {
        
        let image: UIImage = UIImage.init(named: imageName)!
        let button: UIButton = UIButton.init(type: .Custom)
        let frame: CGRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height)
        button.frame = frame
        button.setBackgroundImage(image, forState: .Normal)
        return button
    }
    
    func getListOfDepartments(level1Details: NSArray) -> NSArray {
        
        for detail in level1Details {
            tableIDArray.addObject(detail.objectForKey("tableID")!)
        }
        self.totalCount = level1Details.count + 1
        return tableIDArray
    }
    
    
    func showProgress(countProgress: Int, totalCount: Int){
        
        self.progressVC = GKProgressViewController(nibName: "GKProgressViewController", bundle: nil)
        
        self.progressVC!.currentProgressCount = countProgress
        self.progressVC!.totalCount = totalCount
        
        self.progressVC!.providesPresentationContextTransitionStyle = true;
        self.progressVC!.definesPresentationContext = true;
        self.progressVC!.modalPresentationStyle=UIModalPresentationStyle.OverFullScreen
        self.presentViewController(self.progressVC!, animated: true, completion: nil)
    }
    
    func removeProgressBar() {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)

        }
        
    }
    
    
    func update() {
        
        let notification =  NSNotification(name: "countNotification", object: nil, userInfo: ["count" : self.count])
        NSNotificationCenter.defaultCenter().postNotification(notification)
        
    }
}
