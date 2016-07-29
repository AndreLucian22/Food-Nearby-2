//
//  SettingViewController.swift
//  Food Nearby
//
//  Created by Claire Valentine on 7/12/16.
//  Copyright © 2016 Luc1an. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var MenuButton: UIBarButtonItem!

    @IBOutlet weak var recomendationSwitch: UISwitch!
    
    @IBOutlet weak var priceSlide: UISlider!
    @IBOutlet weak var radiusSlide: UISlider!
    @IBOutlet weak var distanceType: UISegmentedControl!
    @IBOutlet weak var maxRd: UILabel!
    @IBOutlet weak var minRd: UILabel!
    @IBOutlet weak var rdLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    
    
    var dstTpe = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.BlackTranslucent
        self.title="Setting"
        
        
        // Do any additional setup after loading the view.
        if self.revealViewController() !=  nil {
            MenuButton.target = self.revealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
        
        
    }
    
    func rstDs() {
        dstTpe = "";
        if(distanceType.selectedSegmentIndex==0)
        {
            dstTpe = "M"
            radiusSlide.maximumValue=999
        }
        else{
            dstTpe = "KM"
            radiusSlide.maximumValue=3
        }
        radiusSlide.value=1
        maxRd.text=String(Int(radiusSlide.maximumValue)) + " " + dstTpe
        minRd.text=String(Int(radiusSlide.minimumValue)) + " " + dstTpe
        prLabel.text = "Rp " + String(Int(priceSlide.value))
        rdLabel.text=String(Int(radiusSlide.value)) + " " + dstTpe
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetSetting(sender: AnyObject) {
        recomendationSwitch.setOn(true, animated: true)
        distanceType.selectedSegmentIndex=0;
        radiusSlide.value=1
        priceSlide.value=1000
        rstDs()
    }

    @IBAction func prChange(sender: AnyObject) {
        prLabel.text = "Rp " + String(Int(priceSlide.value))
    }
    
    @IBAction func rdChange(sender: AnyObject) {
        rdLabel.text=String(Int(radiusSlide.value)) + " " + dstTpe
    }
    
    @IBAction func dsChange(sender: AnyObject) {
        rstDs()
    }
    
    @IBAction func saveSetting(sender: AnyObject) {
        
        var settingSave = "";
        
        //recomend
        var recomendStatus = ""
        if(recomendationSwitch.on)
        {
            recomendStatus = "YES"
        }
        else{
            recomendStatus = "NO"
        }
        //print()
        
        
        //distance
        dstTpe = "";
        if(distanceType.selectedSegmentIndex==0)
        {
            dstTpe = "M"
        }
        else{
            dstTpe = "KM"
        }
        
        //radius
        var radSearch = radiusSlide.value
        //price
        var prcSearch = priceSlide.value
        
        
        
        settingSave = "RC : " + recomendStatus + "\nDst : " + dstTpe + "\nRds : " + String(radSearch) + "\nPrc : " + String(prcSearch)
        
        print(settingSave)
        
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
