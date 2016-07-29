//
//  ViewController.swift
//  Food Nearby
//
//  Created by Claire Valentine on 7/11/16.
//  Copyright © 2016 Luc1an. All rights reserved.
//

import UIKit

func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
}

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var FBProfileImage: UIImageView!
    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    @IBOutlet weak var FBProfileName: UILabel!
    
    let file = "userData.rtf"
    let myImageName = "imageProfile.png"
    var imagePath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let objObjectiveCFile = IntegretedFB()
        objObjectiveCFile.displayMessageFromCreatedObjectiveCFile()
        
        configureFacebook()
        
        readLogedInUserd()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFacebook()
    {
        FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        FBLoginButton.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        loginButton.alpha=0
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            if(FBSDKAccessToken.currentAccessToken() != nil)
            {
                let strFirstName: String = (result.objectForKey("first_name") as? String)!
                let strLastName: String = (result.objectForKey("last_name") as? String)!
                let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                let userName = "\(strFirstName) \(strLastName)"
                self.FBProfileName.text = "Welcome, \(strFirstName) \(strLastName)"
                self.writeLogedInUser(userName, imagepp: UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!))
                self.FBProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
            }
            else {loginButton.alpha=100}
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        FBProfileImage.image = nil
        FBProfileName.text = ""
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func writeLogedInUser(username: String!, imagepp: UIImage!){
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            let paths = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(myImageName)
            do {
                try username.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                
                saveImage(imagepp, path: paths.path!)
                self.performSegueWithIdentifier("user_confirm", sender: nil)
                print("log")
            }
            catch {/* error handling here */}
        }
    }
    
    
    func clearLogedInUser(){
        let text = " "
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            do {
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }
    }
    
    
    func readLogedInUserd(){
        //this is the file. we will write to and read from it
        var text2=" "
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            let paths = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(myImageName)
            //reading
            do {
                text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
                FBProfileName.text = text2
                if(text2.characters.count>2){
                    self.FBProfileImage.image = UIImage(data: NSData(contentsOfURL: paths)!)
                    self.performSegueWithIdentifier("user_confirm", sender: nil)
                    print("log")
                }
            }
            catch {/* error handling here */}
        }
        
        
    }
    
    func saveImage (image: UIImage, path: String ){
        
        let pngImageData = UIImagePNGRepresentation(image)
        pngImageData!.writeToFile(path, atomically: true)
        
    }





}

