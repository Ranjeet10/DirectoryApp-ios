//
//  GKEditProfileViewController.swift
//  SampleApp
//
//  Created by Ranjeet Sah on 10/16/16.
//  Copyright © 2016 Ranjeet. All rights reserved.
//

import UIKit

class GKEditProfileViewController: UIViewController, HTTPClientDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var showMyProfile: Bool?
    var profileDetails: NSDictionary?
    var newPassword: String?
    var receivedData: NSDictionary?
    var userName: String?
    var userPosition: String?
    var userPhoneNumber: String?
    var uploadPhotoRequest = false
    
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var enterPasswordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPositionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.customizeDetailViewsNavigationBar()
        self.title = "Edit Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.userName = profileDetails!.objectForKey("name") as? String
        self.userPosition = profileDetails!.objectForKey("position") as? String
        self.userPhoneNumber = profileDetails?.objectForKey("mobile") as? String
        
        self.userNameLabel.text = userName
        self.userPositionLabel.text = userPosition
        
        print(profileDetails!)
        
        let imageFetched = self.getImageFromDocuments()
        self.profileImageView.contentMode = .ScaleToFill
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.image = imageFetched
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func updatePassword(sender: AnyObject) {
        
        if self.enterPasswordText.text == self.confirmPasswordText.text {
            self.newPassword = self.enterPasswordText.text
            //  self.updatePassword()
            self.updatePasswordHelper()
        }else {
            self.newPassword = ""
            self.showAlertWithMessage("Passwords dont match")
        }
        
    }
    
    func updatePasswordHelper() {
        
        let url = GKConstants.sharedInstanse.updatePasswordAPI
        let body = "mobile=".stringByAppendingString(self.userPhoneNumber!).stringByAppendingString("&tableID=department2&password=").stringByAppendingString(self.newPassword!)
        let updatePasswordAPIHelper = HTTPClient()
        updatePasswordAPIHelper.delegate = self
        updatePasswordAPIHelper.postRequest(url, body: body)
    }
    
    func didPerformPOSTRequestSuccessfully(resultDict: AnyObject, resultStatus: Bool, url: String, body: String) {
        
        
        let responseFromServerDict = resultDict as! NSDictionary
        
        print("The result is: " + responseFromServerDict.description)
        if responseFromServerDict["error"] as! Bool == false {
            
            if uploadPhotoRequest {
                print("Success")
            }
            else {
                
                self.receivedData = resultDict.objectForKey("user") as? NSDictionary
                
                print(self.receivedData!.objectForKey("name"))
                print(self.receivedData!.objectForKey("email"))
                self.showLoggedInHomePage()

            }
            
            
        }
        self.uploadPhotoRequest = false
        
    }
    
    func didFailWithPOSTRequestError(resultStatus: Bool) {
        print("Error")
        self.showAlertWithMessage("Somethig went wrong")
        self.uploadPhotoRequest = false
    }
    
    func showLoggedInHomePage() {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.popView()
        }
        
        
    }
    
    @IBAction func changePhoto(sender: AnyObject) {
        self.chooseCameraOrGallery()
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let imagenow = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let pickedImage = resizeImage(imagenow, newWidth: 200)
            profileImageView.contentMode = .ScaleToFill
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
            profileImageView.image = pickedImage
            //Save image
            self.saveImageToDocuments(pickedImage)
            self.encodeImageAndUpload(pickedImage)
            self.uploadPhotoRequest = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func chooseCameraOrGallery() {
        
        self.imagePicker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                self.imagePicker.sourceType = .Camera
            }
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: {
            action in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func encodeImageAndUpload(image: UIImage) {
        
        let imageData:NSData = UIImagePNGRepresentation(image)!
        let strBase64Representation:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        self.uploadPhotoToServer(strBase64Representation)
        
    }
    
    func uploadPhotoToServer(imageRepresentationInBase64: String) {
        
        let url = GKConstants.sharedInstanse.uploadPhotoAPI
        let body = "mobile=8105991000&tableID=department2&image=".stringByAppendingString(imageRepresentationInBase64)
        let uploadPhotoAPIHelper = HTTPClient()
        uploadPhotoAPIHelper.delegate = self
        uploadPhotoAPIHelper.postRequest(url, body: body)
                    
    }

}
