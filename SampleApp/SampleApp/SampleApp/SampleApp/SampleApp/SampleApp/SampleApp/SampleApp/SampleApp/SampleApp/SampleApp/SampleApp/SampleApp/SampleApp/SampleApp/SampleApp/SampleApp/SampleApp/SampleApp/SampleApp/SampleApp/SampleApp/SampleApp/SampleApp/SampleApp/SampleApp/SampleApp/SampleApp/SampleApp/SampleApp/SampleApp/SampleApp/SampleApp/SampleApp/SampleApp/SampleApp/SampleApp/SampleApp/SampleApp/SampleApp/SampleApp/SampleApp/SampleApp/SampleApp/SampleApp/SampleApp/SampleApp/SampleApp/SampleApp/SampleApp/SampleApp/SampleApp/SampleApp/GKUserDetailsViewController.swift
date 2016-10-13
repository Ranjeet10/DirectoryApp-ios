//
//  GKUserDetailsViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/7/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKUserDetailsViewController: UIViewController {

    let menuItems = ["profile", "profile", "profile"]
    var insideLevel1Details: NSArray?
    var selectedIndex: Int?
    var individualInsideLevel1Detail: NSDictionary!
    
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    
    @IBOutlet weak var userDepartment: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPosition: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.individualInsideLevel1Detail = insideLevel1Details![selectedIndex!] as! NSDictionary
        let userDepartment = individualInsideLevel1Detail.objectForKey("level1") as? String
        let userName = individualInsideLevel1Detail.objectForKey("name") as? String
        let userPosition = individualInsideLevel1Detail.objectForKey("position") as? String
        
        self.userDepartment.text = userDepartment
        self.userName.text = userName
        self.userPosition.text = userPosition
        
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

}
