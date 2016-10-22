
import UIKit

@objc protocol HTTPClientDelegate{
    
    
    optional func didPerformGETRequestSuccessfully(resultDict:AnyObject,resultStatus:Bool, url: String, body: String)
    optional func didPerformPOSTRequestSuccessfully(resultDict:AnyObject,resultStatus:Bool, url: String, body: String)
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
        let bodyStr:String = body
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        print(request)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling POST request")
                print(error)
                return
            }
            
            do {
                guard let resultDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? NSDictionary else {
                    
                    print("Couldn't convert received data to JSON dictionary")
                    return
                }
                self.delegate?.didPerformPOSTRequestSuccessfully!(resultDict, resultStatus: true, url:url, body:body)
                print("The result is: " + resultDict.description)
                
            } catch  {
                print("error trying to convert data to JSON")
                self.delegate?.didFailWithPOSTRequestError!(false)
            }
            
        }
        task.resume()

    }
    
}