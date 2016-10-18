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
        leftButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func addTitleView(navigationItem:UINavigationItem) {
       // navigationItem.prompt = "GK"
    }
    
    //MARK: Customizing menu controllers navigation
    
    func customizeNavigationBar() {
        
        self.addTitleView(self.navigationItem)
        self.addLeftBarButtonItems()
        navigationController!.navigationBar.barTintColor = self.getUIColorFromHexaString("#D71C25")
    }
    
    func customizeDetailViewsNavigationBar() {
        
        self.addBackButton()
        self.addTitleView(self.navigationItem)
        navigationController!.navigationBar.barTintColor = self.getUIColorFromHexaString("#D71C25")
    }
    
    private func addBackButton() {
        let back:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                                   style: UIBarButtonItemStyle.Plain,
                                                   target: self,
                                                   action: #selector(self.popView))
        back.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = back
    }
    
    
    private func addLeftBarButtonItems() {
        let buttonImage = UIImage(named: "menu")
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage,
                                                          style: UIBarButtonItemStyle.Plain,
                                                          target: self,
                                                          action:#selector(UIViewController.toggleLeft))
        leftButton.tintColor = UIColor.whiteColor()
        
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
    
    func getUIColorFromHexaString(hexString: String) -> UIColor {
        let r, g, b, a: CGFloat
        
        let hexStringWithAlpha = hexString.stringByAppendingString("ff")
        
        if hexStringWithAlpha.hasPrefix("#") {
            let start = hexStringWithAlpha.startIndex.advancedBy(1)
            let hexColor = hexStringWithAlpha.substringFromIndex(start)
            
            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexLongLong(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    return UIColor.init(red: r, green: g, blue: b, alpha: a)
                }
            }
        }
        
        return UIColor.clearColor()
    }
    
    func getImageFromDocuments() -> UIImage {
        
        var imageFetched: UIImage!
        do {
            let fileManager = NSFileManager.defaultManager()
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let imagePAth = (documentsPath as NSString).stringByAppendingPathComponent("profilePic.jpg")
            if fileManager.fileExistsAtPath(imagePAth){
                imageFetched = UIImage(contentsOfFile: imagePAth)
            }else{
                imageFetched = UIImage()
            }
            
        }
        return imageFetched
    }
    
    func saveImageToDocuments(image: UIImage) {
        let fileManager = NSFileManager.defaultManager()
        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("profilePic.jpg")
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFileAtPath(paths as String, contents: imageData, attributes: nil)
    }

    
}

