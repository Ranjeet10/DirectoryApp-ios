
import UIKit

class LibraryAPI: NSObject {
    private let persistencyManager: PersistencyManager
    private let httpClient: HTTPClient
    private let isOnline: Bool
    private var dataLabelUnWrapped: NSDictionary?
    private var dataInsideUnWrapped: NSDictionary?
    
    
    class var sharedInstance: LibraryAPI {
        struct Singleton {
            static let instance = LibraryAPI()
        }
        return Singleton.instance
    }
    
    override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        isOnline = false
        
        super.init()
        
     //   NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(downloadDataArray), name: "BLDownloadDataArrayNotification", object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func downloadDataArray() {
        
        self.dataLabelUnWrapped = self.persistencyManager.getData("level1Data")
        
        if dataLabelUnWrapped != nil {
         NSNotificationCenter.defaultCenter().postNotificationName("GKDetails", object: self, userInfo: ["details":self.dataLabelUnWrapped!])
        }
        
        if dataLabelUnWrapped == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let downloadedData = self.httpClient.downloadData("level1Data")
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.dataLabelUnWrapped = downloadedData
                    self.persistencyManager.saveData(downloadedData)
                    NSNotificationCenter.defaultCenter().postNotificationName("GKDetails", object: self, userInfo: ["details":self.dataLabelUnWrapped!])
                })
            })
        }
    }
    
    func downloadInsideData() {
        
        self.dataInsideUnWrapped = self.persistencyManager.getInsideData("level1InsideData")
        
        if dataInsideUnWrapped != nil {
            NSNotificationCenter.defaultCenter().postNotificationName("GKInsideDetails", object: self, userInfo: ["insideDetails":self.dataInsideUnWrapped!])
        }
        
        if dataInsideUnWrapped == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let downloadedData = self.httpClient.getInsideLevel1Datas("department4")
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.dataInsideUnWrapped = downloadedData
                    self.persistencyManager.saveInsideData(downloadedData)
                    NSNotificationCenter.defaultCenter().postNotificationName("GKInsideDetails", object: self, userInfo: ["insideDetails":self.dataInsideUnWrapped!])
                })
            })
        }
    }
    
    
}
