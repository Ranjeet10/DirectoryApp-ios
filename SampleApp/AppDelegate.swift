//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/5/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainController:GKMainViewController?
    var leftviewController:GKLeftMenuViewController?
    var slideMenuController:GKSlideMenuViewController?
    var level1Details: NSDictionary?
    
    override init() {
        super.init()
        
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let initialViewController = UIViewController()
        self.window!.rootViewController = initialViewController
        self.window!.makeKeyAndVisible()
        self.setupRootViewController(false)
        
        
        if self.isConnectedToNetwork() == false {
            self.showAlertWithMessage("No Internet connection")
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    
    func setupRootViewController(syncData: Bool) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        self.mainController = storyboard.instantiateViewControllerWithIdentifier("GKMainViewController") as? GKMainViewController
        self.mainController?.syncDataFlag = syncData
        
        self.leftviewController = storyboard.instantiateViewControllerWithIdentifier("GKLeftMenuViewController") as? GKLeftMenuViewController
        
        // Creating nav controller with Hamburger back button
        let navVC = UINavigationController(rootViewController: self.mainController!)
        
        // Preparing slide view controller
        
        slideMenuController = GKSlideMenuViewController(mainViewController: navVC, leftMenuViewController: leftviewController!)
        slideMenuController!.automaticallyAdjustsScrollViewInsets = true
        slideMenuController!.delegate = self.mainController
        
        self.window!.rootViewController = slideMenuController
        
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    func showAlertWithMessage(message:String, handler:()?=nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            handler
        }))
        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
