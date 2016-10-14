//
//  ViewController.swift
//  BlipDiag
//
//  Created by Andrew Vu on 10/14/16.
//  Copyright © 2016 Andrew VuAApolloTest. All rights reserved.
//
// Adding comment to test git

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var imgTru: UIImageView!
    @IBOutlet weak var imgMag: UIImageView!
    @IBOutlet weak var txtLat: UILabel!
    @IBOutlet weak var txtLong: UILabel!
    @IBOutlet weak var txtHead: UILabel!
    @IBOutlet weak var txtMagAcc: UILabel!
    
    @IBOutlet weak var txtTrue: UILabel!
    
    var locationManger: CLLocationManager!
    var startLocation: CLLocation!
    var functRunner = Timer()
    var counter: CGFloat = 0.0
    var magH: CGFloat = 0.0
    var truH: CGFloat = 0.0
    var rotateAngleH: CGFloat = 0.0
    var rotateAngleT: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManger = CLLocationManager()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
         locationManger.startUpdatingLocation()
        locationManger.startUpdatingHeading()
       // self.functRunner = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.callULocation), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func callULocation(){
        locationManger.startUpdatingLocation()
        counter = counter + 1
        txtLong.text = String(describing: counter)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        startLocation = locations[0]
        txtLat.text = String(format: "%.4f", startLocation.coordinate.latitude)
        txtLong.text = String(format: "%.4f", startLocation.coordinate.longitude)
        
              
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateHeading newHeading: CLHeading){
        magH = CGFloat(newHeading.magneticHeading)
        truH = CGFloat(newHeading.magneticHeading)
        txtHead.text = String(format: "%.4f", magH)
        txtTrue.text = String(format: "%.4f", truH)
        txtMagAcc.text = String(format: "%.4f", newHeading.headingAccuracy)
        rotateImages()
    }
  
    func rotateImages(){
        UIView.animate(withDuration: 0.5, animations: {
            self.rotateAngleH = 360 - self.magH
            self.rotateAngleT = 360 - self.truH
            self.imgMag.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotateAngleH) * CGFloat(M_PI / 180.0))
            self.imgTru.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotateAngleT) * CGFloat(M_PI / 180.0))})
    
    }
    
}

