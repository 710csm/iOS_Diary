//
//  MapViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/18.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var map: GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(named: "StatusbarColor")
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor(named: "StatusbarColor")
        }
        
        locationManager.delegate = self
          if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            map.isMyLocationEnabled = true
            map.settings.myLocationButton = true
          } else {
            locationManager.requestWhenInUseAuthorization()
          }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        let camera = GMSCameraPosition.camera(withLatitude: 37.88, longitude: 127.73, zoom: 15.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
////      mapView.isMyLocationEnabled = true
//        self.map = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 37.88, longitude: 127.73)
//        marker.map = mapView
//    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {

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


