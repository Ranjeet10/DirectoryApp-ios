
import UIKit

@objc protocol HTTPClientDelegate{
    
    
    optional func didPerformGETRequestSuccessfully(resultDict:AnyObject,resultStatus:Bool)
    optional func didPerformPOSTRequestSuccessfully(resultDict:AnyObject,resultStatus:Bool)
    optional func didFailWithGETRequestError(resultStatus:Bool)
    optional func didFailWithPOSTRequestError(resultStatus:Bool)
    
}


class HTTPClient {
	
    var resultantDict: NSDictionary?
    var delegate:HTTPClientDelegate?
    
    func getRequest(url: String, params: String) {

    }
	
	func postRequest(url: String, body: String) {
        
        let myURL = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
       // let bodyStr:String = "mobile=".stringByAppendingString(phoneNumber)
        let bodyStr:String = body
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            
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
                self.delegate?.didPerformPOSTRequestSuccessfully!(resultDict, resultStatus: true)
                print("The result is: " + resultDict.description)
                if resultDict["error"] as! Bool == false {
                    
                   // let resultArray = resultDict.objectForKey("table") as! NSArray
                    
                    /* self.tableID = resultArray[0].objectForKey("tableID") as? String
                     self.level1 = resultArray[0].objectForKey("level1") as? String
                     
                     dispatch_async(dispatch_get_main_queue()) { () -> Void in
                     self.performSegueWithIdentifier("showUpdatePassword", sender: self)
                     }
                     */
                    
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        // self.showAlertWithMessage("User does not exist")
                    }
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                self.delegate?.didFailWithPOSTRequestError!(false)
            }
            
        }
        task.resume()

    }
    
    func downloadData(url: String) -> NSDictionary {
        
        let aUrl = NSURL(string: "http://directory.karnataka.gov.in/getlevel1.php")
        
        let data = NSData(contentsOfURL: aUrl!)
        
        let resultResponseDict: NSDictionary
                
        do {
            guard let resultDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary else {
                
                print("Couldn't convert received data to JSON dictionary")
                return NSDictionary()
            }
            resultResponseDict = resultDict
            
        } catch  {
            print("error trying to convert data to JSON")
            resultResponseDict = NSDictionary()
        }
        
        return resultResponseDict
      
    }
    
    
    func getInsideLevel1Datas(department: String) ->  NSDictionary {
        
      /*  let myURL = NSURL(string: "http://directory.karnataka.gov.in/getleveldata.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr:String = "level1=".stringByAppendingString(department)
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
       var result: NSDictionary?
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            do {
                guard let resultDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary else {
                    
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                print("The result is: " + resultDict.description)
                if resultDict["error"] as! Bool == false {
                   result = resultDict
                }
                
                
            } catch  {
                print("error trying to convert data to JSON")
                result = NSDictionary()
                
            }
            
        }
        
        if result == nil {
            task.resume()
            result = NSDictionary()
        }
        
        else{
            return result!
        }
        
       return result! */
        
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/getleveldata.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr:String = "level1=".stringByAppendingString(department)
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            
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
                    self.resultantDict = resultDict
                    
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                self.resultantDict = NSDictionary()
            }
            
        }
        task.resume()
        
        return self.resultantDict!
    }
 
    
    
    func getInsideLevel1Data(department: String) {
        
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
                  /*  self.insideLevel1Details = resultDict["data"] as! NSArray
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.insideLevel1DetailsTable.reloadData()
                    }
 */
                    
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
            
        }
        task.resume()
        
    }
    
    
    
    
    
    
    func checkUser(phoneNumber: String) {
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/mobilecheck.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr:String = "mobile=".stringByAppendingString(phoneNumber)
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            
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
                    
                   // let resultArray = resultDict.objectForKey("table") as! NSArray
                    
                   /* self.tableID = resultArray[0].objectForKey("tableID") as? String
                    self.level1 = resultArray[0].objectForKey("level1") as? String
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.performSegueWithIdentifier("showUpdatePassword", sender: self)
                    }
                    */
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                       // self.showAlertWithMessage("User does not exist")
                    }
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
            
        }
        task.resume()
        
    }
    
    func updatePassword() {
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/updatepswrd.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr = "mobile=8105991000&tableID=department2&password=hello1984"
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
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
                    
                /*    self.receivedData = resultDict.objectForKey("user") as? NSDictionary
                    
                    print(self.receivedData!.objectForKey("name"))
                    print(self.receivedData!.objectForKey("email"))
                    self.showLoggedInHomePage()
 */
                    
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
            
        }
        task.resume()
        
    }
    
    func loginUser(password: String) {
        
        let myURL = NSURL(string: "http://directory.karnataka.gov.in/checkpassword.php")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let bodyStr = "mobile=8105991000&tableID=department2&password=".stringByAppendingString(password)
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
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
                    
                  /*  self.receivedData = resultDict.objectForKey("user") as? NSDictionary
                    
                    print(self.receivedData! .objectForKey("name"))
                    
                    self.showLoggedInHomePage()
 */
                    
                }
                else {
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                     //   self.showAlertWithMessage("Password is incorrect")
                    }
                    
                    
                }
                
            } catch  {
                print("error trying to convert data to JSON")
            }
            
        }
        task.resume()
        
    }
    
}