//
//  ResultViewController.swift
//  Food Nearby
//
//  Created by Claire Valentine on 7/26/16.
//  Copyright © 2016 Luc1an. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var listRestaurant:Array<Dictionary<String, String>> = []
    @IBOutlet var scrView: UIScrollView!
    let name: [String] = ["http://static1.squarespace.com/static/55b61816e4b0b4cd5d2ccd9f/562f9352e4b062e141f9641b/5649a99be4b08143f94957cf/1447668125609/06.BenguelaBrasserie-dFood.jpg","http://cdn.playbuzz.com/cdn/df02649d-894e-4b82-94da-cd10dd2449a0/7833c7a7-6301-446b-8fbc-ed948aaaa0be.jpg","http://www.mrwallpaper.com/wallpapers/dragon-rider-1-1680x1050.jpg","http://cdn.playbuzz.com/cdn/503aeb8a-c1b8-4679-8ed3-da5e11643f29/8a940ebd-8630-4247-888e-c4c611f4f0e2.jpg"]
    

    
    
    
    var pageView: UIView!
    
    var cardView: [UIView] = []
    var backView: [UIImageView] = []
    var frontView: [UIImageView] = []
    
    
    var detailString = [String]()
    var backViewDetail: [UILabel] = []
    
    var indexOpened = -1;
    var isOpened:Bool = false;
    
    var listName = ["pic0.png","pic1.png","pic2.png","pic3.png","pic5.png"]
    
    var showingBack = [Bool]()
    var checked = [Bool]()
    var cardName = [String]()
    
    var countDta = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countDta = listRestaurant.count
        //print(listRestaurant.count)
        for i in 0..<listRestaurant.count {
           print(listRestaurant[i]["Nama"]! + "result")
            //print(listRestaurant[i]["Nama"]! + "\n")

        }

        if(CGFloat(countDta)/3*105>550)
        {
        pageView = UIView(frame:CGRectMake(0, 0, 320, (CGFloat(countDta)/3*105)+50))
        }
        else
        {
          pageView = UIView(frame:CGRectMake(0, 0, 320, 600))
        }
        pageView.backgroundColor = UIColor.blueColor()
        self.scrView.contentSize=CGSizeMake(320,(CGFloat(countDta)/3*105)+50)
        for i in 0...countDta-1 {
            

            


            let singleTap = UITapGestureRecognizer(target: self, action: #selector(ResultViewController.tapped))
            singleTap.numberOfTapsRequired = 1
            
            showingBack.append(false);
            checked.append(false);
            
            frontView.append(UIImageView(frame:CGRectMake(10, 5, 80, 80)))
            backView.append(UIImageView(frame:CGRectMake(10, 10, 200, 200)))
            backViewDetail.append(UILabel(frame:CGRectMake(10, 230, 300, 200)))
            
            
            let imgURL: NSURL = NSURL(string: listRestaurant[i]["Image"]!)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data!)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.frontView[i].image = image
                        self.backView[i].image = image
                    })
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
            
            detailString.append(" ")
            detailString[i] = detailString[i] + listRestaurant[i]["Nama"]! + "\n"
            detailString[i] = detailString[i] + "Alamat : " + listRestaurant[i]["Alamat"]! + "\n"
            //detailString[i] = detailString[i] + "Jam buka : " + listRestaurant[i]["Jam"]! + "\n"
            //detailString[i] = detailString[i] + "Kisaran harga : " + listRestaurant[i]["Harga"]! + "\n"
            detailString[i] = detailString[i] + "Info  : " + listRestaurant[i]["Keterangan"]! + "\n"
            
            
            let rect = CGRectMake(CGFloat(i%3*105)+5, CGFloat((i/3)*105)+10, 100, 100)
            cardView.append(UIView(frame:rect))
            cardView[i].intrinsicContentSize()
            cardView[i].addGestureRecognizer(singleTap)
            cardView[i].userInteractionEnabled = true
            cardView[i].backgroundColor = UIColor.grayColor()
            cardView[i].addSubview(frontView[i])
            pageView.addSubview(cardView[i])
            
            
        }
        //pageView.addSubview(foodsview)
        self.scrView.addSubview(pageView)
        
        
        
    }
    
    func tapped(sender:UITapGestureRecognizer) {
        let px  = floor((sender.locationInView(scrView).x-5) / 105)
        let py = floor((sender.locationInView(scrView).y-10) / 105)
        var curIndex = Int(px + py * 3)
        print("klcik")
        if(isOpened){curIndex = indexOpened}
        
        if (showingBack[curIndex]) {
            UIView.transitionFromView(backView[curIndex], toView: frontView[curIndex], duration: 1.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack[curIndex] = false
            let seconds = 0.75
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                
                // here code perfomed with delay
                self.cardView[curIndex].frame = CGRectMake(CGFloat(curIndex%3*105)+5, CGFloat((curIndex/3)*105)+10, 100, 100)
            })
            //pageView = UIView(frame:CGRectMake(0, 0, 320, (21/3*105)+20))
            self.scrView.contentSize=CGSizeMake(320,(21/3*105)+50)
            isOpened=false;
            backViewDetail[curIndex].removeFromSuperview()
        }
        else
        {
            UIView.transitionFromView(frontView[curIndex], toView: backView[curIndex], duration: 1.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack[curIndex] = true
            cardView[curIndex].frame = CGRectMake(0,0,320,520)
            self.scrView.contentSize=CGSizeMake(320,500)
            
            backViewDetail[curIndex].backgroundColor = UIColor.yellowColor()
            backViewDetail[curIndex].text=detailString[curIndex]
            cardView[curIndex].addSubview(backViewDetail[curIndex])
            
            isOpened = true
            indexOpened = curIndex
            pageView.bringSubviewToFront(cardView[curIndex])

        }
        print(curIndex)
        
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
