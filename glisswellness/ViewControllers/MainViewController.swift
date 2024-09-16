//
//  ViewController.swift
//  gliss
//
//  Created by Kyaw Zin on 06/09/2024.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation


class MainViewController: UIViewController {
    let App = UIApplication.shared.delegate as! AppDelegate
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var locationManager: CLLocationManager?
    
   
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        spinner.startAnimating()
        
        if(isConnectedToInternet()){
            callValidateDevice()
        }else{
            let confirmAlert = UIAlertController(title: "Erro in connection.", message: "Please check your internet connection and try again.", preferredStyle: UIAlertController.Style.alert)
            
            confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                confirmAlert.dismiss(animated: true)
            }))
            
            self.present(confirmAlert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("viewDidLoad")
        
        initLocationManager()
    }
    
    
    func callValidateDevice(){
        Router.sharedInstance().ValidateDevice(deviceid: getDeviceID()) { [self] response in
            if(response.responsemessage?.uppercased() == "SUCCESS"){
                
                App.CurrentUser = response.user
                
                let vc = self.storyBoard.instantiateViewController(withIdentifier: "CheckInViewController") as! CheckInViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                let vc = self.storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } failure: { error in
            print(error.description)
        }

    }


}


extension MainViewController: CLLocationManagerDelegate{
   
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("When user did not yet determined")
            case .restricted:
                print("Restricted by parental control")
            case .denied:
                print("When user select option Dont't Allow")
            case .authorizedWhenInUse:
                print("When user select option Allow While Using App or Allow Once")
            default:
                print("default")
            }
    }
    
    func initLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        
        Task { [weak self] in
            if ((await CLLocationManager.locationServicesEnabled()) != nil) {
                self!.locationManager!.delegate = self
                self!.locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self!.locationManager!.startUpdatingLocation()
            }
        }
    }
    
//   func initLocationManager(){
//      locationManager.requestAlwaysAuthorization()
//      locationManager.requestWhenInUseAuthorization()
//
//       if CLLocationManager.locationServicesEnabled() {
//         locationManager.delegate = self
//         locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//         locationManager.startUpdatingLocation()
//      }
//   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
      //print("locations = \(locValue.latitude) \(locValue.longitude)")
      
      App.lat = locValue.latitude
      App.lng = locValue.longitude
      
      getAddressFromLatLon(pdblLatitude: String(locValue.latitude), pdblLongitude:  String(locValue.longitude))
   }
   
    
   func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
      var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
      let lat: Double = Double("\(pdblLatitude)")!
      //21.228124
      let lon: Double = Double("\(pdblLongitude)")!
      //72.833770
      let ceo: CLGeocoder = CLGeocoder()
      center.latitude = lat
      center.longitude = lon
      
      let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
      
    
      
      ceo.reverseGeocodeLocation(loc, completionHandler:
                                    { [self](placemarks, error) in
                                       if (error != nil)
                                       {
                                          print("reverse geodcode fail: \(error!.localizedDescription)")
                                       }
                                       
          
                                      guard let placemarks = placemarks else {
                                                        App.fullAddress = "NA"
                                                        return
                                                  }
          
                                      if let pm = placemarks.first {
                                          var addressString : String = ""
                                          if pm.subLocality != nil {
                                             addressString = addressString + pm.subLocality! + ", "
                                          }
                                          if pm.thoroughfare != nil {
                                              addressString = addressString + pm.thoroughfare! + ", "
                                          }
                                          if pm.locality != nil {
                                             addressString = addressString + pm.locality! + ", "
                                          }
                                          if pm.country != nil {
                                             addressString = addressString + pm.country! + ", "
                                          }
                                          if pm.postalCode != nil {
                                             addressString = addressString + pm.postalCode! + " "
                                          }
                                          
                                          App.fullAddress = addressString //.replaceEscapeChr
                                          print(App.fullAddress)
                                      }
                                    })
   }
}

