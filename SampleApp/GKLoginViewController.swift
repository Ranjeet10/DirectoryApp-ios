//
//  GKLoginViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/6/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit
import MessageUI

class GKLoginViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var inputNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    

    
    
    @IBAction func sendInAppSMS(sender: AnyObject) {
    
     /*   if MFMessageComposeViewController.canSendText() {
            
      
        let controller: MFMessageComposeViewController = MFMessageComposeViewController()
        controller.body = "Hello"
        controller.recipients = ["9686050932"]
        controller.messageComposeDelegate = self
        self.presentViewController(controller, animated: true, completion: nil)
        
        }
 */
        if inputNumberField.text == "12345" {
            print("logged in")
            
            self.showAlert("Successfully Logged In")
                        
            let notification = NSNotification.init(name: "LoggedInMenu", object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
        else {
            self.showAlertWithMessage("Wrong Credentials")
        }
        
        
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



    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result {
        case MessageComposeResultCancelled:
            NSLog("Cancelled")
        break
        case MessageComposeResultFailed:
            let alert = UIAlertController.init(title: "My App", message: "unknown error", preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            break
            
        case MessageComposeResultSent:
            print("Sent")
            break
        default:
            break
        }
    }
    
    
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            self.popView()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
