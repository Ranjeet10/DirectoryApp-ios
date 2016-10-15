//
//  GKLoginAppViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/14/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKLoginAppViewController: UIViewController,HTTPClientDelegate {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var enterPasswordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var phoneNumber: String?
    var tableID: String = ""
    var level1: String = ""
    var receivedData: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.phoneNumberLabel.text = phoneNumber
        
       // self.checkUser("")
        self.checkUserHelper()
        
      //  self.loginUser("")
        self.customizeDetailViewsNavigationBar()
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
    
    @IBAction func loginAction(sender: AnyObject){
        self.loginUser("")
    }
    
    @IBAction func forgotPasswordAction(sender: AnyObject){
        
        self.performSegueWithIdentifier("forgotPasswordSegue", sender: self)
    }
    
    
  /*  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showUpdatePassword" {
            
            let loginController:GKLoginViewController = segue.destinationViewController as! GKLoginViewController
            
        }
    }
 */
    
    
    func checkUserHelper() {
        
        let url = GKConstants.sharedInstanse.checkUserAPI
        let body = "mobile=".stringByAppendingString("8105991000")
        let checkUserAPIHelper = HTTPClient()
        checkUserAPIHelper.delegate = self
        checkUserAPIHelper.postRequest(url, body: body)
    }
    
    func didPerformPOSTRequestSuccessfully(resultDict: AnyObject, resultStatus: Bool) {
        
        
        let responseFromServerDict = resultDict as! NSDictionary
        
        print("The result is: " + resultDict.description)
        if responseFromServerDict["error"] as! Bool == false {
            
            let resultArray = responseFromServerDict.objectForKey("table") as! NSArray
            
            self.tableID = resultArray[0].objectForKey("tableID") as! String
            self.level1 = resultArray[0].objectForKey("level1") as! String
            
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

    
    
    
    
    
 /*   func checkUser(phoneNumber: String) {
    
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/mobilecheck.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr:String = "mobile=".stringByAppendingString("8105991000")
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
                    
                    let resultArray = resultDict.objectForKey("table") as! NSArray
                    
                    self.tableID = resultArray[0].objectForKey("tableID") as! String
                    self.level1 = resultArray[0].objectForKey("level1") as! String
                    
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
            
        }
        task.resume()

        
        
    }
 */
 
    
    
    func loginUser(phoneNumber: String) {
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/checkpassword.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr = "mobile=8105991000&tableID=department2&password=".stringByAppendingString(self.enterPasswordText.text!)
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
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
                    
                     self.receivedData = resultDict.objectForKey("user") as? NSDictionary
                    
                    print(self.receivedData! .objectForKey("name"))
                    
                    self.showLoggedInHomePage()

                }
                else {
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.showAlertWithMessage("Password is incorrect")
                    }

                    
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
            
        }
        task.resume()        
        
    }
    
    func showLoggedInHomePage() {
        
        let notification = NSNotification.init(name: "LoggedInMenu", object: self, userInfo: ["userDetails": self.receivedData!])
        
        NSNotificationCenter.defaultCenter().postNotification(notification)
            
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.popView()
        }
        
    }
    
    

}
