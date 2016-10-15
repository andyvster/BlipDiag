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

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtTarLong: UITextField!
    @IBOutlet weak var txtTarLat: UITextField!
    @IBOutlet weak var txtCourse: UILabel!
    @IBOutlet weak var imgMag1: UIImageView!
    @IBOutlet weak var imgTru: UIImageView!
    @IBOutlet weak var imgMag: UIImageView!
    @IBOutlet weak var txtLat: UILabel!
    @IBOutlet weak var txtLong: UILabel!
    @IBOutlet weak var txtHead: UILabel!
    @IBOutlet weak var txtMagAcc: UILabel!
    
    @IBOutlet weak var txtTruAng: UILabel!
    @IBOutlet weak var txtMagAng: UILabel!
    @IBOutlet weak var txtTrue: UILabel!
    
    var locationManger: CLLocationManager!
    var startLocation: CLLocation!
    var prevLocation: CLLocation!
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
       txtTarLat.delegate = self
        txtTarLong.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func callULocation(){
        locationManger.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        startLocation = locations[0]
        txtLat.text = String(format: "%.8f", startLocation.coordinate.latitude)
        txtLong.text = String(format: "%.8f", startLocation.coordinate.longitude)
        txtCourse.text = String(format: "%.4f", startLocation.course)
        
              
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateHeading newHeading: CLHeading){
        magH = CGFloat(newHeading.magneticHeading)
        truH = CGFloat(newHeading.trueHeading)
        txtHead.text = String(format: "%.4f", magH)
        txtTrue.text = String(format: "%.4f", truH)
        txtMagAcc.text = String(format: "%.4f", newHeading.headingAccuracy)
        rotateImages()
    }
  
    func rotateImages(){
        
            self.rotateAngleH = 360 - self.magH
            self.rotateAngleT = 360 - self.truH
            txtTruAng.text = String(format: "%.2f",rotateAngleT)
            txtMagAng.text = String(format: "%.2f", rotateAngleH)
        UIView.animate(withDuration: 0.5, animations: {
            self.imgMag1.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotateAngleH) * CGFloat(M_PI / 180.0))})
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imgTru.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotateAngleT) * CGFloat(M_PI / 180.0))})
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

