//
//  MapsVC.swift
//  Peta
//
//  Created by Ferry jati on 08/10/23.
//

import UIKit
import MapKit
import CoreLocation


class MapsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
  
  @IBOutlet weak var lblCurrentLocataion: UILabel!
  @IBOutlet weak var mapKit: MKMapView!
  @IBOutlet weak var btnSelectLocation: UIButton!
  
  var address: String?
  var delegate: MapsVC?
  var locationManager = CLLocationManager()
  var locTitle = ""
  func actConfirm(loc: String){
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      setUpView()
      setAction()
    }
  func setUpView(){
    btnSelectLocation.setTitle("Select Location", for: .normal)
    lblCurrentLocataion.text = locTitle
  
  }
  
  
  func setAction(){
    mapKit.delegate = self
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    btnSelectLocation.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
    
  }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse{
      //start updating user lcoation
      mapKit.showsUserLocation = true
      locationManager.startUpdatingLocation()
    }
  }
    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            centerMapOnLocation(location: location)
            addPinpointToMap(coordinate: location.coordinate)
            getAddressFromLocation(location: location)
        }
    }

    // MARK: - Map Methods

    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000 // Adjust as needed
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapKit.setRegion(coordinateRegion, animated: true)
    }

    func addPinpointToMap(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapKit.addAnnotation(annotation)
    }

    // MARK: - Reverse Geocoding

    func getAddressFromLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                if let address = placemark.name,
                    let city = placemark.locality,
                    let state = placemark.administrativeArea,
                    let country = placemark.country {
                    print("Address: \(address), City: \(city), State: \(state), Country: \(country)")
                    self.locTitle = ("\(address), \(city), \(state), \(country)")
                    self.lblCurrentLocataion.text = self.locTitle
                }
            }
        }
    }
      @objc func selectLocation(){
        self.delegate?.actConfirm(loc: locTitle)
      }

}
