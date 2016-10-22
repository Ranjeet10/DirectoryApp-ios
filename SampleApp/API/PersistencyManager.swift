//
//  PersistenceManager.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/19/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    override init() {
        super.init()
    }
    
    /*func saveData(data: NSDictionary, filename: String) {
        
        let path = NSHomeDirectory().stringByAppendingString(filename)
        
        do {
            let resultData = try NSJSONSerialization.dataWithJSONObject(data, options: [])
            resultData.writeToFile(path, atomically: true)
            
        } catch  {
            print("error trying to convert data to JSON")
        }
        
    }
    
    func getData(filename: String) -> NSDictionary? {
        
        var resultResponseDict: NSDictionary?
        let path = NSHomeDirectory().stringByAppendingString(filename)
        
        let data: NSData?
        do {
            data = try NSData(contentsOfFile: path, options: .UncachedRead)
            
            guard let resultDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary else {
                
                print("Couldn't convert data to JSON dictionary")
                return NSDictionary()
            }
            resultResponseDict = resultDict
            
        } catch {
            print("An error was encountered")
            resultResponseDict = NSDictionary()
        }
        
        return resultResponseDict
    }*/
    
    func saveData(data: NSDictionary, filename: String) {
        
        let path = NSHomeDirectory().stringByAppendingString("level1Data")
        
        do {
            let resultData = try NSJSONSerialization.dataWithJSONObject(data, options: [])
            resultData.writeToFile(path, atomically: true)
            
        } catch  {
            print("error trying to convert data to JSON")
        }
        
    }
    
    func getData(filename: String) -> NSDictionary? {
        
        var resultResponseDict: NSDictionary?
        let path = NSHomeDirectory().stringByAppendingString("level1Data")
        
        let data: NSData?
        do {
            data = try NSData(contentsOfFile: path, options: .UncachedRead)
            
            guard let resultDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary else {
                
                print("Couldn't convert data to JSON dictionary")
                return NSDictionary()
            }
            resultResponseDict = resultDict
            
        } catch {
            print("An error was encountered")
            resultResponseDict = nil
        }
        
        return resultResponseDict
    }

    
}

