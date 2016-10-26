//
//  GKAboutAppViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/5/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKAboutAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About App"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view.
        self.customizeDetailViewsNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
