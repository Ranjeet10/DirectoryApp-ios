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
    
    
    func customizeNavigationBar() {
        
        self.addLeftBarButtonItems()
        navigationController!.navigationBar.barTintColor = self.getUIColorFromHexaString("#D71C25")
    }
    
    func customizeDetailViewsNavigationBar() {
        
        self.addBackButton()
        navigationController!.navigationBar.barTintColor = self.getUIColorFromHexaString("#D71C25")
    }
    
    private func addBackButton() {
        let back:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_white"),
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
    
    func getLoggedInMenu() {
        
    }
    
    func getLoggedOutMenu() {
        
    }
    
    
    func getBacKButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.setBackButtonBackgroundImage(UIImage(named: "back_white"), forState: .Normal, barMetrics: .Default)
        navigationItem.backBarButtonItem = backItem
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
                imageFetched = UIImage(named: "profile")
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
    
    func saveDataToDocuments(data: NSDictionary, filename: String) {
        
        let fileManager = NSFileManager.defaultManager()
        let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(filename)
        
        do {
            let resultData = try NSJSONSerialization.dataWithJSONObject(data, options: [])
            fileManager.createFileAtPath(path as String, contents: resultData, attributes: nil)
        } catch  {
            print("error trying to convert data to JSON")
        }
        
    }
    
    func getDataFromDocuments(filename: String) -> NSDictionary {
        
        var resultResponseDict: NSDictionary!
        do {
            let fileManager = NSFileManager.defaultManager()
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let dataPAth = (documentsPath as NSString).stringByAppendingPathComponent(filename)
            if fileManager.fileExistsAtPath(dataPAth){
                
                do {
                   let data = try NSData(contentsOfFile: dataPAth, options: .UncachedRead)
                    
                    guard let resultDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                        
                        print("Couldn't convert data to JSON dictionary")
                        return NSDictionary()
                    }
                    resultResponseDict = resultDict
                    
                } catch {
                    print("An error was encountered")
                    resultResponseDict = nil
                }
                
            }else{
                resultResponseDict = NSDictionary()
            }
            
        }
        return resultResponseDict
        
    }
    
}

