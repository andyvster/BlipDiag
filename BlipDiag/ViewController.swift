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

    @IBOutlet weak var txtLat: UILabel!
    @IBOutlet weak var txtLong: UILabel!
    @IBOutlet weak var txtHead: UILabel!
    @IBOutlet weak var txtMagAcc: UILabel!
    
    var locationManger: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var functRunner = Timer()
    var counter: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        self.functRunner = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.callULocation), userInfo: nil, repeats: true)
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
    
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {   startLocation = newLocation
        txtLat.text = "Is This Being Called?"
       // txtLat.text = String(format: "%.4f", startLocation.coordinate.latitude)
        print(String(format: "%.4f", startLocation.coordinate.latitude))
        
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        txtLat.text = "Error"
    }
}

