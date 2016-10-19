//
//  GKLoginViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/6/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit
    
class GKLoginViewController: UIViewController, HTTPClientDelegate{

    @IBOutlet weak var inputNumberField: UITextField!
    var tableID: String?
    var level1: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Get Code"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Do any additional setup after loading the view.
        self.customizeDetailViewsNavigationBar()
       // self.checkUser("")
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
    
    
    
    @IBAction func sendInAppSMS(sender: AnyObject) {
        
        if self.inputNumberField.text != "" {
            self.checkUserHelper()
        }
        else {
            self.showAlertWithMessage("Please enter a number")
        }

        
    
     /*   if MFMessageComposeViewController.canSendText() {
            
      
        let controller: MFMessageComposeViewController = MFMessageComposeViewController()
        controller.body = "Hello"
        controller.recipients = ["9686050932"]
        controller.messageComposeDelegate = self
        self.presentViewController(controller, animated: true, completion: nil)
        
        }
 
        if inputNumberField.text == "12345" {
            print("logged in")
            
           // self.showAlert("Successfully Logged In")
          //  self.performSegueWithIdentifier("showLoginScreen", sender: self)
            self.checkUser("")
            self.performSegueWithIdentifier("showUpdatePassword", sender: self)
                        
          //  let notification = NSNotification.init(name: "LoggedInMenu", object: nil)
          //  NSNotificationCenter.defaultCenter().postNotification(notification)
            
         //   let defaults = NSUserDefaults.standardUserDefaults()
         //   defaults.setBool(true, forKey: "hasLoggedInSecond")
            
        }
        else {
            self.showAlertWithMessage("Wrong Number")
        }
 */
 
    }
    
    
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            self.popView()
          //  self.performSegueWithIdentifier("showLoginScreen", sender: self)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func checkUserHelper() {
        
        let url = GKConstants.sharedInstanse.checkUserAPI
        let body = "mobile=".stringByAppendingString(self.inputNumberField.text!)
        let checkUserAPIHelper = HTTPClient()
        checkUserAPIHelper.delegate = self
        checkUserAPIHelper.postRequest(url, body: body)
    }
    
    func didPerformPOSTRequestSuccessfully(resultDict: AnyObject, resultStatus: Bool, url: String) {
        
        
        let responseFromServerDict = resultDict as! NSDictionary
        
        print("The result is: " + responseFromServerDict.description)
        if responseFromServerDict["error"] as! Bool == false {
            
            let resultArray = resultDict.objectForKey("table") as! NSArray
            
            self.tableID = resultArray[0].objectForKey("tableID") as? String
            self.level1 = resultArray[0].objectForKey("level1") as? String
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
               // self.performSegueWithIdentifier("showUpdatePassword", sender: self)
                self.performSegueWithIdentifier("verifyCodeSegue", sender: self)
            }
            
        }
        else {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.showAlertWithMessage("User does not exist")
            }
        }
        
    }
    
    func didFailWithPOSTRequestError(resultStatus: Bool) {
        print("Error")
        self.showAlertWithMessage("Somethig went wrong")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "verifyCodeSegue" {
            let verifyCodeController: GKVerifyCodeViewController = segue.destinationViewController as! GKVerifyCodeViewController
            
            verifyCodeController.phoneNumber = self.inputNumberField.text
            verifyCodeController.tabelID =  self.tableID
            
        }
    }
    
}
