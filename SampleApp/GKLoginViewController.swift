//
//  GKLoginViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/6/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit
    
class GKLoginViewController: UIViewController {

    @IBOutlet weak var inputNumberField: UITextField!
    var tableID: String?
    var level1: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.checkUser("")
    
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
    
    
/*    - (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
    {
    switch (result) {
    case MessageComposeResultCancelled:
    NSLog(@"Cancelled");
    break;
    case MessageComposeResultFailed:
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp" message:@"Unknown Error"
    delegate:self cancelButtonTitle:@”OK” otherButtonTitles: nil];
    [alert show];
    [alert release];
    break;
    case MessageComposeResultSent:
    
    break;
    default:
    break;
}

[self dismissModalViewControllerAnimated:YES];
}*/
    
    
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            self.popView()
          //  self.performSegueWithIdentifier("showLoginScreen", sender: self)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
  /*  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showLoginScreen" {
            
            let loginController:GKLoginAppViewController = segue.destinationViewController as! GKLoginAppViewController
            loginController.phoneNumber = self.inputNumberField.text
            //loginController.tableID = self.tableID!
            //loginController.level1 = self.level1!
            
        }
    }
 */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showUpdatePassword" {
            
            let updatePasswordController:GKUpdatePasswordViewController = segue.destinationViewController as! GKUpdatePasswordViewController
            updatePasswordController.phoneNumber = inputNumberField.text
            
        }
    }
    
    
    func checkUser(phoneNumber: String) {
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/mobilecheck.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr:String = "mobile=".stringByAppendingString(self.inputNumberField.text!)
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
                    
                    let resultArray = resultDict.objectForKey("table") as! NSArray
                    
                    self.tableID = resultArray[0].objectForKey("tableID") as? String
                    self.level1 = resultArray[0].objectForKey("level1") as? String
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.performSegueWithIdentifier("showUpdatePassword", sender: self)
                    }
                    
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.showAlertWithMessage("User does not exist")
                    }
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
            
        }
        task.resume()
        
    }
    
}
