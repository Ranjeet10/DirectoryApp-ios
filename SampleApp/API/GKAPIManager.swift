//
//  GKAPIManager.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/5/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import Foundation

//typealias ServiceResponse = (JS, NSError?) -> Void
//
//class GKAPIManager: NSObject {
//    static let sharedInstance = GKAPIManager()
//    
//    let baseURL = "http://api.randomuser.me/"
//    
//    func getRandomUser(onCompletion: (NSDictionary) -> Void) {
//        let route = baseURL
//        makeHTTPGetRequest(route, onCompletion: { json, err in
//            onCompletion(json as NSDictionary)
//        })
//    }
//    
//    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
//        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
//        
//        let session = NSURLSession.sharedSession()
//        
//        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            let json:NSDictionary = NSDictionary(dictionary: data)
//            onCompletion(json, error)
//        })
//        task.resume()
//    }
//}
