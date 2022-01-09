//
//  MapViewController.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 26.12.2021.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
    func setAddressText(address: String)
}

class MapViewController: UIViewController {
    var outputAddressText: String = ""
    var outputAddressLabel: UITextField? = nil
    
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    
    @IBAction func backButton(_ sender: Any) {
        
        
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        outputAddressLabel?.text = outputAddressText
        
        backButton(self)
    }
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            
            self.navigationController!.navigationBar.backgroundColor = .white.withAlphaComponent(0.5)
            
            let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
            resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            resultSearchController?.searchResultsUpdater = locationSearchTable
            
            let searchBar = resultSearchController!.searchBar
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for places"
            navigationItem.searchController = resultSearchController
            
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            definesPresentationContext = true
            
            locationSearchTable.mapView = mapView
            locationSearchTable.handleMapSearchDelegate = self
        }
}
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
             print("error:: \(error.localizedDescription)")
        }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
//            print("location:: (location)")
//            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            let region = MKCoordinateRegion(center: location.coordinate, span: span)
//                mapView.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    func setAddressText(address: String) {
        outputAddressText = address
    }
}
