
import UIKit

class PersistencyManager: NSObject {
    
    override init() {
        super.init()
    }
    
    func saveData(data: NSDictionary) {
        
        let path = NSHomeDirectory().stringByAppendingString("level1Data")
        
        do {
            let resultData = try NSJSONSerialization.dataWithJSONObject(data, options: [])
            resultData.writeToFile(path, atomically: true)
            
        } catch  {
            print("error trying to convert data to JSON")
        }
        
    }
    
    func saveInsideData(data: NSDictionary) {
        
        let path = NSHomeDirectory().stringByAppendingString("level1InsideData")
        
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
    
    func getInsideData(filename: String) -> NSDictionary? {
        
        var resultResponseDict: NSDictionary?
        let path = NSHomeDirectory().stringByAppendingString("level1InsideData")
        
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
