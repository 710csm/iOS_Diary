//
//  AddMapViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/20.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import GoogleMaps

class AddMapViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var map: GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
          if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            map.isMyLocationEnabled = true
            map.settings.myLocationButton = true
          } else {
            locationManager.requestWhenInUseAuthorization()
          }
    }
    
    // MARK: Action Method
    @IBAction func cancel(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
}

// MARK: - CLLocationManagerDelegate
extension AddMapViewController: CLLocationManagerDelegate {

  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {

    guard status == .authorizedWhenInUse else {
      return
    }

    locationManager.requestLocation()


    map.isMyLocationEnabled = true
    map.settings.myLocationButton = true
  }


  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }


    map.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
  }


  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print(error)
  }
    
}




