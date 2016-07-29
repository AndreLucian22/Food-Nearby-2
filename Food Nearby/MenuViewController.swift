//
//  MenuViewController.swift
//  Food Nearby
//
//  Created by Claire Valentine on 7/11/16.
//  Copyright © 2016 Luc1an. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {



    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!

    
    
    let name: [String] = ["Search","History","Submit","Setting","Other"]
    let image: [String] = ["menu2.png","menu2.png","menu2.png","menu2.png","menu2.png"]
    let segueTarget: [String] = ["search_push","history_push","submit_push","setting_push","other_push"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        
        
        
        
        var text2=" "

        
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width / 2;
        self.ProfileImage.clipsToBounds = true;
        self.ProfileImage.layer.borderWidth = 3.0
        self.ProfileImage.layer.borderColor? = UIColor.whiteColor().CGColor
        self.ProfileImage.layer.cornerRadius = (self.ProfileImage.frame.size.width ) / 2;
        
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("userData.rtf")
            let paths = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("imageProfile.png")
            //reading
            do {
                text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
                ProfileName.text = text2
                self.ProfileImage.image = UIImage(data: NSData(contentsOfURL: paths)!)
            }
            catch {/* error handling here */}
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func logOutAccount(sender: AnyObject) {
        /*
        FBSDKAccessToken.currentAccessToken()
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        let text = " "
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("userData.rtf")
            do {
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }
        */
        let refreshAlert = UIAlertController(title: "Log Out", message: "Are you sure want to log out ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Log out", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
            FBSDKAccessToken.currentAccessToken()
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()
            let text = " "
            if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("userData.rtf")
                do {
                    try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                }
                catch {/* error handling here */}
            }
            self.revealViewController().revealToggleAnimated(true)
            self.performSegueWithIdentifier("logout_push", sender: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.revealViewController().revealToggleAnimated(true)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    

    
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        //let imageName = image[indexPath.row]
        //cell.imageView.image = UIImage(named: imageName)
        cell.textLabel?.text=name[indexPath.row]
        let images = UIImage(named: image[indexPath.row])
        cell.imageView?.image=images
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(name[indexPath.row])
        self.performSegueWithIdentifier(segueTarget[indexPath.row], sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
