//
//  GKVerifyCodeViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/15/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKVerifyCodeViewController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var editMobileNumberButton: UIButton!
    
    var randNum: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.generateRandomNumbers()
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
    
    @IBAction func verifyButtonAction(sender: AnyObject) {
        self.verifyCode()
    }
    
    @IBAction func editNumberButtonAction(sender: AnyObject) {
        self.performSegueWithIdentifier("showGetCodeViewSegue", sender: self)
    }
    
    func verifyCode() {
        
        if self.codeTextField.text! == "\(self.randNum)" {
            self.performSegueWithIdentifier("showUpdatePasswordSegue", sender: self)
        }
        else {
            self.showAlertWithMessage("Wrong code")
        }
        
    }
    
    
    func generateRandomNumbers() {
        
        var number:UInt32 = 0
        var randomNumber: UInt32?
        var i = 0
        while i <= 5 {
            randomNumber = arc4random_uniform(10)
            if randomNumber != 0 {
                number =  number * 10 + randomNumber!
                i += 1
            }
        }
        self.codeTextField.text! = "\(number)"
        self.randNum = "\(number)"
        
    }
}
