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
    var userPhoneNumber: String?
    var departamentName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Forgot Password"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.phoneNumberLabel.text = self.userPhoneNumber
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updatePasswordAction(sender: AnyObject) {
        
        if self.enterPasswordText.text == self.confirmPasswordText.text {
            self.newPassword = self.enterPasswordText.text
            self.updatePasswordHelper()
        }else {
            self.newPassword = ""
            self.showAlertWithMessage("Passwords dont match")
        }
        
    }
    
    
    func updatePasswordHelper() {
        
        let url = GKConstants.sharedInstanse.updatePasswordAPI
        let body = "mobile=".stringByAppendingString(self.userPhoneNumber!).stringByAppendingString("&tableID=").stringByAppendingString(departamentName!).stringByAppendingString("&password=").stringByAppendingString(self.newPassword!)
        let updatePasswordAPIHelper = HTTPClient()
        updatePasswordAPIHelper.delegate = self
        updatePasswordAPIHelper.postRequest(url, body: body)
    }
    
    func didPerformPOSTRequestSuccessfully(resultDict: AnyObject, resultStatus: Bool, url: String, body: String) {
        
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
    
    func showLoggedInHomePage() {
        
        GKUserDefaults.setValueInDefaults(self.receivedData, forKey: kUserInfo)
        GKUserDefaults.setBoolInDefaults(true, forKey: kSecondLogIn)
        GKUserDefaults.setBoolInDefaults(true, forKey: kLoggedIn)
        GKUserDefaults.setValueInDefaults(self.userPhoneNumber, forKey: kPhoneNumber)
        GKUserDefaults.setValueInDefaults(self.departamentName, forKey: kDepartmentName)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.popView()
            let loggedInMenuController = GKConstants.sharedInstanse.dynamicMenuStoryBoard.instantiateViewControllerWithIdentifier("GKLoggedInMenuViewController") as! GKLoggedInMenuViewController
            
            self.slideMenuController()?.changeLeftViewController(loggedInMenuController, closeLeft: true)
            
        }
        
        
    }
    
    
}
