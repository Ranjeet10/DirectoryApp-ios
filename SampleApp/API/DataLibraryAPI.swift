//
//  DataLibrary.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/19/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class DataLibraryAPI: NSObject, HTTPClientDelegate {
    
    class var sharedInstance: DataLibraryAPI {
        
        struct Singleton {
            
            static let instance = DataLibraryAPI()
        }
        
        return Singleton.instance
    }
    
    private let persistencyManager: PersistencyManager
    private let httpClient: HTTPClient
    private var details: NSDictionary
    
    override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        details = NSDictionary()
        
        super.init()
        
    }
    
    func getLevel1DetailsArray() -> NSDictionary {
        
        return NSDictionary()
    }
    
    
    func getLevel1Data() {
        
        let url = "http://directory.karnataka.gov.in/getlevel1.php"
        let level1DataAPIHelper = HTTPClient()
        level1DataAPIHelper.delegate = self
        level1DataAPIHelper.postRequest(url, body: "")
    }
    
    func getInsideLevel1Data() {
        
        
        
    }
    
    
    func didPerformPOSTRequestSuccessfully(resultDict: AnyObject, resultStatus: Bool, url: String, body: String) {
        
        let responseFromServerDict = resultDict as! NSDictionary
        
        print("The result is: " + responseFromServerDict.description)
        
        if responseFromServerDict["error"] as! Bool == false {
            
            self.persistencyManager.saveData(responseFromServerDict, filename: "level1Data")
            
            NSNotificationCenter.defaultCenter().postNotificationName("GKLevel1Details", object: self, userInfo: ["details":responseFromServerDict])
        }
    }
    
    func didFailWithPOSTRequestError(resultStatus: Bool) {
        print("Error")
    }
    
    
  /*  func getLevel1Details(filename: String) {
        
        let level1DetailsArray = persistencyManager.getData("helloFile")!
        NSNotificationCenter.defaultCenter().postNotificationName("GKLevel1Details", object: self, userInfo: ["details":level1DetailsArray])

        
        if level1DetailsArray.count == 0 {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.getLevel1Data()
               
            })
        }else {
            NSNotificationCenter.defaultCenter().postNotificationName("GKLevel1Details", object: self, userInfo: ["details":level1DetailsArray])
        }
    }
    */
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
    
    
    func downloadDataArray() {
        
        let dataLabelUnWrapped = self.persistencyManager.getData("level1Data")
        
        if dataLabelUnWrapped != nil {
            NSNotificationCenter.defaultCenter().postNotificationName("GKLevel1Details", object: self, userInfo: ["details":dataLabelUnWrapped!])
        }
        
        if dataLabelUnWrapped == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
              //  let downloadedData = self.httpClient.downloadData("level1Data")
                
                self.getLevel1Data()
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                  //  self.dataLabelUnWrapped = downloadedData
                  //  self.persistencyManager.saveData(downloadedData)
                  //  NSNotificationCenter.defaultCenter().postNotificationName("GKDetails", object: self, userInfo: ["details":self.dataLabelUnWrapped!])
                })
            })
        }
    }
    
   
}

