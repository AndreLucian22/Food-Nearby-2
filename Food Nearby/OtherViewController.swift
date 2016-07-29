//
//  OtherViewController.swift
//  Food Nearby
//
//  Created by Claire Valentine on 7/15/16.
//  Copyright © 2016 Luc1an. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    @IBOutlet weak var MenuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.BlackTranslucent
        self.title="Other"
        
        
        // Do any additional setup after loading the view.
        if self.revealViewController() !=  nil {
            MenuButton.target = self.revealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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

}
