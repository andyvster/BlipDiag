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

    @IBOutlet weak var txtBearTar: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
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
    
    @IBOutlet weak var txtCurLat: UILabel!
    @IBOutlet weak var txtDistInc: UILabel!
    
    @IBOutlet weak var txtTarC: UILabel!
    @IBOutlet weak var txtTarH: UILabel!
    @IBOutlet weak var imgTarCs: UIImageView!
    @IBOutlet weak var imgTarHead: UIImageView!
    var locationManger: CLLocationManager!
    var startLocation: CLLocation!
    var courseLocation: CLLocation!
    var functRunner = Timer()
    var counter: CGFloat = 0.0
    var magH: CGFloat = 0.0
    var truH: CGFloat = 0.0
    var rotateAngleH: CGFloat = 0.0
    var rotateAngleT: CGFloat = 0.0
    var rotateAngleTH: CGFloat = 0.0
    var rotateAngleTC: CGFloat = 0.0
    var targetLat: Double = 0.0
    var targetLong: Double = 0.0
    var bearing: CGFloat = 0.0
    var courseD: CGFloat = 0.0
    var targetLocation: CLLocationCoordinate2D!
    
    // New
    var threshDist: CGFloat = 0.0
    var firstRun: Int = 0
    var offsetter: CGFloat = 0.0
    var magAcc: CGFloat = 0.0
    
    @IBAction func goBut(_ sender: AnyObject) {
        self.targetLat = Double(txtTarLat.text!)!
        self.targetLong = Double(txtTarLong.text!)!
        self.targetLocation = CLLocationCoordinate2D.init(latitude: targetLat, longitude: targetLong)
    }
    
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
        if self.firstRun == 0 {
            self.startLocation = locations[0]
            self.courseLocation = self.startLocation
            self.firstRun = 1
        }
        if courseLocation != nil {
            self.threshDist = CGFloat(courseLocation.distance(from: locations[0])) * 3.28084
            self.txtDistInc.text = String(format: "%.8f", self.threshDist)
            if threshDist >= 40.0{
                // get the course
                self.courseD = getHeadingForDirectionFromCoordinate(fromLoc: courseLocation.coordinate, toCoordinate: locations[0].coordinate)
                self.courseLocation = locations[0]
                self.startLocation = locations[0]
                self.offsetter = self.magH - self.courseD
                if targetLocation != nil{
                    self.bearing = getHeadingForDirectionFromCoordinate(fromLoc: startLocation.coordinate, toCoordinate: targetLocation)
                }
            }
        }
  
        
   
        txtLat.text = String(format: "%.8f", locations[0].coordinate.latitude)
        txtLong.text = String(format: "%.8f", locations[0].coordinate.longitude)
        txtCurLat.text = String(format: "%.8f", startLocation.coordinate.latitude)
        txtTrue.text = String(format: "%.8f", startLocation.coordinate.longitude)
        
        if self.courseD < 0 {
            self.courseD = self.courseD + 360
        }
        
        
        txtCourse.text = String(format: "%.4f", self.courseD)
        if targetLocation != nil{
            if self.magAcc >= 45 {
                self.rotateAngleT = self.bearing - self.magH + self.offsetter
            }else{
                self.startLocation = locations[0]
                self.bearing = getHeadingForDirectionFromCoordinate(fromLoc: startLocation.coordinate, toCoordinate: targetLocation)
                self.rotateAngleT = self.bearing - self.magH
            }
        
            txtBearTar.text = String(format: "%.4f", bearing)
            getDistance()
            rotateImages()
        }
        

        
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateHeading newHeading: CLHeading){
        magH = CGFloat(newHeading.magneticHeading)
        truH = CGFloat(newHeading.trueHeading)
        txtHead.text = String(format: "%.4f", magH)
        
        txtMagAcc.text = String(format: "%.4f", newHeading.headingAccuracy)
        self.magAcc = CGFloat(newHeading.headingAccuracy)
        if self.magAcc >= 45 {
            self.rotateAngleT = self.bearing - self.magH + self.offsetter
        }else{
            self.rotateAngleT = self.bearing - self.magH
        }
        
        rotateImages()
    
    }
  
    
    func degreesToRadians(x: Double) -> Double {
        return (M_PI * x / 180.0)
    }
    
    func radiansToDegrees(x: Double)  -> Double {
        return (x * 180.0 / M_PI)
    }
    
    func getHeadingForDirectionFromCoordinate(fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> CGFloat {
        let fLat: Double = degreesToRadians(x: fromLoc.latitude)
        let fLng: Double = degreesToRadians(x: fromLoc.longitude)
        let tLat: Double = degreesToRadians(x: toLoc.latitude)
        let tLng: Double = degreesToRadians(x: toLoc.longitude)
        let degree: Double = radiansToDegrees(x: atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng)))
        if degree >= 0 {
            return CGFloat(degree)
        }
        else {
            return 2 * CGFloat(M_PI) + CGFloat(degree)
        }
    }
    
    func getDistance() {
        
            let locA = CLLocation(latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
            let locB = CLLocation(latitude: targetLocation.latitude, longitude: targetLocation.longitude)
            let distance = locA.distance(from: locB)
            
            
            if distance / 1609.344 >= 1 {
                self.distanceLabel.text = String(format: "%.2f", (distance / 1609.344)) +  " miles"
            } else {
                if distance * 3.28084 < 30.0 {
                    self.distanceLabel.text = "Less than 30 ft"
                } else {
                    self.distanceLabel.text = String(format: "%.2f", (distance * 3.28084)) +  " ft"
                }
                
            }
            
        
        
    }
    
    func rotateImages(){
        
            self.rotateAngleH = 360 - self.magH
         
            self.rotateAngleTH = self.bearing - self.magH
            self.rotateAngleTC = self.bearing - self.courseD
        
        if rotateAngleTH < 0 {
            rotateAngleTH = rotateAngleTH + 360
        }
        if rotateAngleTC < 0 {
            rotateAngleTC = rotateAngleTC + 360
        }
        if rotateAngleT < 0 {
            rotateAngleT = rotateAngleT + 360
        } else if rotateAngleT > 360 {
            rotateAngleT = rotateAngleT + -360
    }
            txtTruAng.text = String(format: "%.2f",rotateAngleT)
            txtMagAng.text = String(format: "%.2f", rotateAngleH)
            txtTarH.text = String(format: "%.2f", rotateAngleTH)
            txtTarC.text = String(format: "%.2f", rotateAngleTC)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imgMag1.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotateAngleH) * CGFloat(M_PI / 180.0))})
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imgTru.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotateAngleT) * CGFloat(M_PI / 180.0))})
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imgTarHead.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotateAngleTH) * CGFloat(M_PI / 180.0))})
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imgTarCs.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotateAngleTC) * CGFloat(M_PI / 180.0))})
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

