//
//  GKConstants.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/15/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKConstants: NSObject {
    
    
    let level1API = "http://directory.karnataka.gov.in/getlevel1.php"
    let insideLeveldata1API = "http://directory.karnataka.gov.in/getleveldata.php"
    let checkUserAPI = "http://directory.karnataka.gov.in/mobilecheck.php"
    let loginUserAPI = "http://directory.karnataka.gov.in/checkpassword.php"
    let updatePasswordAPI = "http://directory.karnataka.gov.in/updatepswrd.php"
    
    
    /* ============== Singleton =============== */
    
    static let sharedInstanse : GKConstants = GKConstants()
    private override init() {}

}
