//
//  GKInsideLevel1DetailsViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/6/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

import UIKit

class GKInsideLevel1DetailsViewController: UIViewController {
    
    var insideLevel1Details: NSArray?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.customizeNavigationBar()
        
       print(insideLevel1Details)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insideLevel1Details!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InsideLevel1TableViewCell") as! InsideLevel1TableViewCell
        let individualInsideLevel1Detail = insideLevel1Details![indexPath.row] as! NSDictionary
        
        cell.insideLevel1Position.text = individualInsideLevel1Detail["position"] as? String
        cell.insideLevel1Name.text = individualInsideLevel1Detail["name"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
    }

    
}
