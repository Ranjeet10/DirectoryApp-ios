
import UIKit

class HTTPClient {
	
    var resultantDict: NSDictionary?
    
	func getRequest(url: String) -> (AnyObject) {
		return NSData()
	}
	
	func postRequest(url: String, body: String) -> (AnyObject){
		return NSData()
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
    
}