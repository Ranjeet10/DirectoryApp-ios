//
//  AIGTGAPIRetryViewController.swift
//  AIGTravelAssist
//
//  Created by s.dudsaheb on 23/09/16.
//  Copyright © 2016 AIG. All rights reserved.
//

import UIKit

class GKProgressViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var currentProgress: UILabel!
    @IBOutlet weak var currentProgressRatio: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    var currentProgressCount: Int?
    var totalCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentProgress.text = "\(self.currentProgressCount!)"
        self.currentProgressRatio.text = "\(self.currentProgressCount!)/100"
        
        self.downloadProgress(self.currentProgressCount!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateProgressView(_:)), name: "countNotification", object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    func updateProgressView(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        let count = userInfo["count"] as! Int
        print("RK Count\n ")
        print(count)
        self.downloadProgress(count)
        
    }
    
    func downloadProgress(currentProgress: Int) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.progressView.progress = (self.getPercentage(currentProgress, den: self.totalCount!).0)/100
            self.currentProgress.text = self.getPercentage(currentProgress, den: self.totalCount!).1
            self.currentProgressRatio.text = (self.getPercentage(currentProgress, den: self.totalCount!).1).stringByAppendingString("/100")
            
        }
        
    }
    
    func getPercentage(num: Int, den: Int) -> (Float, String) {
        
        let percentage = Float((Float(num)/Float(den)) * 100)
        let percentageInt = Int(percentage)
        let percentageString = String(percentageInt)
        return(percentage, percentageString)
        
    }
    
}
