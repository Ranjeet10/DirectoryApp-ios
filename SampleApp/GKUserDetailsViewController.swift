//
//  GKUserDetailsViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/7/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKUserDetailsViewController: UIViewController {

    let menuItems = ["email", "contact", "location"]
    var insideLevel1Details: NSArray?
    var selectedIndex: Int?
    var individualInsideLevel1Detail: NSDictionary!
    
    
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    
    @IBOutlet weak var userDepartmentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPositionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var userDepartment: String?
    var userName: String?
    var userPosition: String?
    var showMyProfile: Bool?
    var profileDetails: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.customizeDetailViewsNavigationBar()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if self.showMyProfile! {
            self.individualInsideLevel1Detail = profileDetails
            self.title = "My Profile"
            let imageFetched = self.getImageFromDocuments()
            self.profileImageView.contentMode = .ScaleToFill
            self.profileImageView.layer.borderWidth = 1
            self.profileImageView.layer.masksToBounds = false
            self.profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            self.profileImageView.clipsToBounds = true
            self.profileImageView.image = imageFetched
        }
        
        else {
            self.individualInsideLevel1Detail = insideLevel1Details![selectedIndex!] as! NSDictionary
            self.title = "Profile"
            
        }
        
        self.userDepartment = individualInsideLevel1Detail.objectForKey("level1") as? String
        self.userName = individualInsideLevel1Detail.objectForKey("name") as? String
        self.userPosition = individualInsideLevel1Detail.objectForKey("position") as? String
    
        
        self.userDepartmentLabel.text = userDepartment
        self.userNameLabel.text = userName
        self.userPositionLabel.text = userPosition
        
        self.userDetailsTableView.estimatedRowHeight = 100
        self.userDetailsTableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserDetailsTableViewCell") as! UserDetailsTableViewCell
        let userEmail = individualInsideLevel1Detail.objectForKey("email") as? String
        let userMobile = individualInsideLevel1Detail.objectForKey("mobile") as? String
        let userAddress = individualInsideLevel1Detail.objectForKey("address") as? String
    
        if indexPath.row == 0 {
            cell.cellLabel.text = userEmail
            cell.cellImage.image = UIImage(named: menuItems[indexPath.row])
        }
        if indexPath.row == 1 {
            cell.cellLabel.text = userMobile
            cell.cellImage.image = UIImage(named: menuItems[indexPath.row])
        }
        if indexPath.row == 2 {
            cell.cellLabel.text = userAddress
            cell.cellImage.image = UIImage(named: menuItems[indexPath.row])
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let userEmail = individualInsideLevel1Detail.objectForKey("email") as? String
        let userMobile = individualInsideLevel1Detail.objectForKey("mobile") as? String
        
        if indexPath.row == 0 {
            self.emailHandler(userEmail!)
        }
        if indexPath.row == 1 {
            self.phoneHandler(userMobile!)
        }
        
    }
    
    func emailHandler(emailAddress:String) {
        
        if let emailURL:NSURL = NSURL(string: "mailto://"+emailAddress) {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(emailURL)) {
                application.openURL(emailURL)
            }
        }
    }
    
    func phoneHandler(mobileNo:String) {
        
        let cleanedString = (mobileNo.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789-+()").invertedSet))
        
        let stringPhoneNo = cleanedString.joinWithSeparator("")
        
        if let phoneCallURL:NSURL = NSURL(string: "tel://"+stringPhoneNo) {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
}
