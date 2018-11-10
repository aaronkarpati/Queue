//
//  MapViewController.swift
//  Queue
//
//  Created by Áron Kárpáti on 2018. 11. 10..
//  Copyright © 2018. Áron Kárpáti. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {


    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    @IBOutlet weak var queMapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    
   override func viewDidLoad() {
        super.viewDidLoad()
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoomLevel)
    queMapView.camera = camera
    showMarker(position: camera.target)
    
    }
    
    // Creates a marker in the center of the map.
    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Palo Alto"
        marker.snippet = "San Francisco"
        marker.map = queMapView
    }


}

