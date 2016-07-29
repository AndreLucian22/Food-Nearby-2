//
//  SearchViewController.swift
//  Food Nearby
//
//  Created by Claire Valentine on 7/11/16.
//  Copyright © 2016 Luc1an. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var MenuButton: UIBarButtonItem!
    @IBOutlet weak var labelRadius: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelMaxD: UILabel!
    @IBOutlet weak var labelMinD: UILabel!
    @IBOutlet weak var sliderRadius: UISlider!
    @IBOutlet weak var sliderPrice: UISlider!
    @IBOutlet weak var txtInfo: UILabel!
    @IBOutlet weak var txtKeyword: UITextField!
    
    var radius = 1
    var price = 1000
    var distanceType="M"
    var listRestaurant:Array<Dictionary<String, String>> = []
    
    
    var myLat = 0.1
    var myLong = 0.1
    
    var myLocalicity = ""
    var myPostalCode = ""
    var myAdministrativeArea = ""
    var myCountry = ""
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.BlackTranslucent
        self.title="Search"
        
        //self.listRestaurant = [[:]]

        // Do any additional setup after loading the view.
        if self.revealViewController() !=  nil {
            MenuButton.target = self.revealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        updateLabel()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myCoor = locations[locations.count - 1]
        
        /*
        print("LOCATION 0")
        print(locations[0])
        print("LOCATION REC")
        print(locations[locations.count - 1])
        */
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })

        
        // get lat and longit
        
        myLat = myCoor.coordinate.latitude
        
        myLong = myCoor.coordinate.longitude
    
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
            locationManager.stopUpdatingLocation()
            myLocalicity = placemark.locality!
            myPostalCode = placemark.postalCode!
            myAdministrativeArea = placemark.administrativeArea!
            myCountry = placemark.country!
        var msg = "Latitude : " + String(myLat) + ", Longitude : " + String(myLong)
        msg += "\n" + myLocalicity + ", " + myPostalCode + " ," + myAdministrativeArea + " ," + myCountry + "\n"
        print(msg)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSearch(sender: UIButton) {
        let keyword:String = txtKeyword.text!
        
        listRestaurant = []
        fetchDataFromServer(keyword, radius: "10", price: "10000")
        //print(listRestaurant.count)
        
        
        
    }
    
    func fetchDataFromServer(keyword:String, radius:String, price:String){
        let parameters = [
            "keyword": keyword,
            "radius": radius,
            "price": price
        ]
        //self.listRestaurant = [[:]]
        Alamofire.request(.POST, "http://127.0.0.1:8888/fetchRestaurant.php", parameters: parameters)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result.value?.objectForKey("datawarna"))
                //print(response.result.value)
                //let jsonResult = response.result.value as! Dictionary<String,AnyObject>
                
                let dataRestaurant = response.result.value!["data"] as! Array<AnyObject>
                var dataResto:String=""
                for i in 0..<dataRestaurant.count {
                    //print(dataRestaurant[i]["Nama"])
                    var tempData:[String : String] = [:]
                    
                    tempData["Nama"] = (dataRestaurant[i]["Nama"] as! String)
                    
                    tempData["Telp"] = (dataRestaurant[i]["Telp"] as! String)
                    
                    tempData["Alamat"] = (dataRestaurant[i]["Alamat"] as! String)
                    
                    tempData["Keterangan"] = (dataRestaurant[i]["Keterangan"] as! String)
                
                    tempData["Latitude"] = String(dataRestaurant[i]["Latitude"] as! NSNumber)
                    
                    tempData["Longitude"] = String(dataRestaurant[i]["Longitude"] as! NSNumber)
                    
                    tempData["Image"] = (dataRestaurant[i]["image"] as! String)
                    
                    self.listRestaurant.append(tempData)
                    print(self.listRestaurant.count)
                    
                    dataResto += (dataRestaurant[i]["Nama"] as! String) + "\n"
                    dataResto += (dataRestaurant[i]["Telp"] as! String) + "\n"
                    dataResto += (dataRestaurant[i]["Alamat"] as! String) + "\n"
                    dataResto += (dataRestaurant[i]["Keterangan"] as! String) + "\n"
                    dataResto += String(dataRestaurant[i]["Latitude"] as! NSNumber) + "\n"
                    dataResto += String(dataRestaurant[i]["Longitude"] as! NSNumber) + "\n"
                    dataResto += (dataRestaurant[i]["image"] as! String) + "\n\n"
                    
                    //print(tempData as! String);
                    
                    self.txtInfo.text = dataResto
                }
                self.performSegueWithIdentifier("pushSearch", sender: self.listRestaurant)
        }
       
        }

    @IBAction func changedDistance(sender: AnyObject) {
        if(sender.selectedSegmentIndex==0)
        {
                distanceType="M"
                sliderRadius.maximumValue=999
        }
        else
        {
                distanceType="KM"
                sliderRadius.maximumValue=3
        }
        radius=1
        sliderRadius.value=1
        radius=1
        updateLabel()
    }
    
    @IBAction func radSlides(sender: AnyObject) {
        updateLabel()
    }
    @IBAction func priceSlides(sender: AnyObject) {
        updateLabel()
    }
    func updateLabel()
    {
        labelMaxD.text=String(Int(sliderRadius.maximumValue)) + " " + distanceType
        labelPrice.text="Rp " + String(Int(sliderPrice.value)) + ",-"
        labelRadius.text=String(Int(sliderRadius.value)) + " " + distanceType
        labelMinD.text=String(Int(sliderRadius.minimumValue)) + " " + distanceType
        if(sliderPrice.value/1000 >= 1)
        {
            labelPrice.text="Rp " + String(Int(sliderPrice.value/1000)) + "." + String(Int(sliderPrice.value%1000)) + ",-"
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier=="pushSearch")
        {
            (segue.destinationViewController as! ResultViewController).listRestaurant = (sender as! Array<Dictionary<String, String>>)
        }
    }
    

}
