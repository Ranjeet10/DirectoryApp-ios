//
//  GKUpdatePasswordViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/14/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKUpdatePasswordViewController: UIViewController,HTTPClientDelegate {

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var enterPasswordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var updatePasswordButton: UIButton!
    
    var newPassword: String?
    var phoneNumber: String?
    var receivedData: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.phoneNumberLabel.text = phoneNumber
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
    
    @IBAction func updatePasswordAction(sender: AnyObject) {
     
        if self.enterPasswordText.text == self.confirmPasswordText.text {
            self.newPassword = self.enterPasswordText.text
          //  self.updatePassword()
            self.updatePasswordHelper()
        }else {
            self.newPassword = ""
            self.showAlertWithMessage("Passwords dont match")
        }
        
    }
    
    
    func updatePasswordHelper() {
        
        let url = GKConstants.sharedInstanse.updatePasswordAPI
        let body = "mobile=8105991000&tableID=department2&password=hello1984"
        let updatePasswordAPIHelper = HTTPClient()
        updatePasswordAPIHelper.delegate = self
        updatePasswordAPIHelper.postRequest(url, body: body)
    }
    
    func didPerformPOSTRequestSuccessfully(resultDict: AnyObject, resultStatus: Bool) {
        
        
        let responseFromServerDict = resultDict as! NSDictionary
        
        print("The result is: " + responseFromServerDict.description)
        if responseFromServerDict["error"] as! Bool == false {
            
            self.receivedData = resultDict.objectForKey("user") as? NSDictionary
            
            print(self.receivedData!.objectForKey("name"))
            print(self.receivedData!.objectForKey("email"))
            self.showLoggedInHomePage()
            
        }
        
    }
    
    func didFailWithPOSTRequestError(resultStatus: Bool) {
        print("Error")
        self.showAlertWithMessage("Somethig went wrong")
    }
    
    
 /*   func updatePassword() {
        
            let myURL = NSURL(string: "http://directory.karnataka.gov.in/updatepswrd.php")!
            let request = NSMutableURLRequest(URL: myURL)
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let bodyStr = "mobile=8105991000&tableID=department2&password=hello1984"
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
                        
                        print(self.receivedData!.objectForKey("name"))
                        print(self.receivedData!.objectForKey("email"))
                        self.showLoggedInHomePage()
                        
                    }
                    
                } catch  {
                    print("error trying to convert data to JSON")
                }
                
            }
            task.resume()        
                    
    }
  */
    
    func showLoggedInHomePage() {
        
        let notification = NSNotification.init(name: "LoggedInMenu", object: self, userInfo: ["userDetails": self.receivedData!])
        NSNotificationCenter.defaultCenter().postNotification(notification)
        
        let defaults = NSUserDefaults.standardUserDefaults()
           defaults.setBool(true, forKey: "hasLoggedInSecond")
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.popView()
        }
        
        
    }


}
