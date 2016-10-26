
//
//  GKUserDefaults.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/26/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

let kLoggedIn = "isLoggedIn"
let kUserInfo = "userInfo"
let kSecondLogIn = "hasLoggedInSecond"
let kPhoneNumber = "PhoneNumber"
let kDepartmentName = "department"

class GKUserDefaults: NSObject {
    
    class func setValueInDefaults(value:AnyObject?,forKey key:String) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getValueFromDefaultsForKey(key:String) ->AnyObject? {
        return NSUserDefaults.standardUserDefaults().valueForKey(key)
    }
    
    class func setBoolInDefaults(value:Bool,forKey key:String) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key)
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getBoolFromDefaultsForKey(key:String) ->Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }


}
