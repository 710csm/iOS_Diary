//
//  AddMapViewController.swift
//  TimeTable
//
//  Created by 최승명 on 2020/09/20.
//  Copyright © 2020 최승명. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddMapViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var address: UILabel!
    
    let locationManager = CLLocationManager()
    
    static var location = String()
    var position: CLLocationCoordinate2D?
    var selectedPlace: GMSPlace?
    var likelyPlaces: [GMSPlace] = []
    var placesClient: GMSPlacesClient!
    var marker = GMSMarker()
    
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

        self.map.delegate = self
    }
    
    // MARK: Action Method
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        AddMapViewController.location = address.text!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getLocation"),object: nil)
        
        doneAlert()
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
      let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { [self] response, error in

        guard let address = response?.firstResult(), let lines = address.lines else {
            return
        }

        self.address.text = lines.joined(separator: "\n")
        
        if position == nil{
            position = CLLocationCoordinate2D(latitude: 37, longitude: 127)
        }
            
        marker = GMSMarker(position: self.position!)
        marker.title = lines.joined(separator: "\n")
        marker.map = self.map
        
      }
    }
    
    // MARK: Func Method
    func doneAlert(){
        let alert = UIAlertController(title: "저장", message: "저장되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default){
            [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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


  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }


    map.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
    
    self.position = location.coordinate
  }


  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print(error)
  }

}

// MARK: - GMSMapViewDelegate
extension AddMapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      reverseGeocode(coordinate: position.target)
    }



    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        map.clear()
        reverseGeocode(coordinate: coordinate)
        self.position = coordinate
    }
}




