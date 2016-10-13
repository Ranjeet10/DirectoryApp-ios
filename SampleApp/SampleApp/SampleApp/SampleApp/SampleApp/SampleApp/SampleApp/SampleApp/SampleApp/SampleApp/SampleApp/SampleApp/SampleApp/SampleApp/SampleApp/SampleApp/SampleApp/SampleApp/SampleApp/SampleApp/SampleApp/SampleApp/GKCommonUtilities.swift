//
//  GKCommonUtilities.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/6/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

extension UIViewController {
    public func slideMenuController() -> GKSlideMenuViewController? {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let slideController = delegate.slideMenuController
        
        if slideController != nil {
            return slideController!
        }
        return nil;
    }
    
    func leftSlideViewController() -> GKLeftMenuViewController? {
        let leftview:GKLeftMenuViewController = (slideMenuController()?.leftViewController as? GKLeftMenuViewController)!
        
        return leftview
    }
    
    //MARK: Page navigation
    func customizeHomeNavigationBar() {
        self.addHomeLeftBarButton()
        self.addTitleView(self.navigationItem)
    }
    
    private func addHomeLeftBarButton() {
        let buttonImage = UIImage(named: "menu")
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage,
                                                          style: UIBarButtonItemStyle.Plain,
                                                          target: self,
                                                          action:#selector(UIViewController.toggleLeft))
        //navigationItem.rightBarButtonItem = leftButton;
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func addTitleView(navigationItem:UINavigationItem) {
       // navigationItem.prompt = "GK"
    }
    
    //MARK: Customizing menu controllers navigation
    
    func customizeNavigationBar() {
        self.addTitleView(self.navigationItem)
        self.addLeftBarButtonItems()
        navigationController!.navigationBar.barTintColor = UIColor.brownColor()
    }
    
    func customizeDetailViewsNavigationBar() {
        self.addBackButton()
        self.addTitleView(self.navigationItem)
        navigationController!.navigationBar.barTintColor = UIColor.brownColor()
    }
    
    private func addBackButton() {
        let back:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                                   style: UIBarButtonItemStyle.Plain,
                                                   target: self,
                                                   action: #selector(self.popView))
        navigationItem.leftBarButtonItem = back
    }
    
    
    private func addLeftBarButtonItems() {
        let buttonImage = UIImage(named: "menu")
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage,
                                                          style: UIBarButtonItemStyle.Plain,
                                                          target: self,
                                                          action:#selector(UIViewController.toggleLeft))
        
        navigationItem.leftBarButtonItems = [leftButton]
    }
    
    
    func popView() {
        //self.navigationController?.popViewControllerAnimated(true)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("GKMainViewController") as! GKMainViewController
        
        let navVC = UINavigationController(rootViewController: mainViewController)
        self.slideMenuController()?.changeMainViewController(navVC, close: true)
    }
    
    func showAlertWithMessage(message:String, handler:()?=nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            handler
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    public func toggleLeft() {
        slideMenuController()?.toggleLeft()
    }
    
    public func openLeft() {
        slideMenuController()?.openLeft()
    }
    
    public func closeLeft() {
        slideMenuController()?.closeLeft()
    }
    
}

