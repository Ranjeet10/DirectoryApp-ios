//
//  GKAPIManager.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/5/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

@objc protocol GKAPIManagerDelegate{
    
    
    optional func didReceivelevel1DetailsResponseSuccessfully(resultDict:AnyObject,resultStatus:Bool)
    optional func didFailWithlevel1DetailsError(resultStatus:Bool)
    
    optional func didReceiveinsideLevel1DetailsSuccessfully(resultDict:AnyObject,resultStatus:Bool)
    optional func didFailinsideLevel1DetailsError(resultStatus:Bool)
    
}


class GKAPIManager: NSObject {
    
    static let sharedInstance : GKAPIManager = GKAPIManager()
    
    private override init() {
    }
    
    var delegate:GKAPIManagerDelegate?

    func getLevel1Details() {
        
        var level1Details:NSArray?
        let getLevel1: String = "http://directory.karnataka.gov.in/getlevel1.php"
        guard let url = NSURL(string: getLevel1) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET request")
                print(error)
                return
            }
            do {
                guard let resultDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? NSDictionary else {
                    
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                print("The result is: " + resultDict.description)
                
                if resultDict["error"] as! Bool == false {
                    level1Details = resultDict["level1"] as? NSArray
                    self.delegate?.didReceivelevel1DetailsResponseSuccessfully!(level1Details!, resultStatus: true)
                }
                
                
            } catch  {
                print("error trying to convert data to JSON")
                self.delegate?.didFailWithlevel1DetailsError!(false)
            }
        }
        task.resume()
    }
    
    func getInsideLevel1Data(department: String) {
        
         var insideLevel1Details:NSArray?
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/getleveldata.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr:String = "level1=".stringByAppendingString(department)
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Your completion handler code here
            
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET request")
                print(error)
                return
            }
            
            do {
                guard let resultDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? NSDictionary else {
                    
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                print("The result is: " + resultDict.description)
                if resultDict["error"] as! Bool == false {
                    insideLevel1Details = resultDict["data"] as? NSArray
                    self.delegate?.didReceiveinsideLevel1DetailsSuccessfully!(insideLevel1Details!, resultStatus: true)
                    
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                self.delegate?.didFailinsideLevel1DetailsError!(false)
            }
            
        }
        task.resume()
        
    }
    
}
