//
//  MapViewController.swift
//  Queue
//
//  Created by Áron Kárpáti on 2018. 11. 10..
//  Copyright © 2018. Áron Kárpáti. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase
import GeoFire

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var queMapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let geofireRef = Database.database().reference().child("Queues")
    var marketTitle = String()
    

    
   override func viewDidLoad() {
        super.viewDidLoad()
    
    //Location Manager code to fetch current location
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    queMapView.delegate = self
    
    
    //Map
    queMapView.isMyLocationEnabled = true
    
    }
    
    
    @IBAction func joinQ(_ sender: Any) {
        let username = Auth.auth().currentUser?.displayName!
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let data = [username: true]
        geofireRef.child(marketTitle).updateChildValues(data)
        print("joined")
        
    }
    
    @IBAction func leaveQ(_ sender: Any) {
        let username = Auth.auth().currentUser?.displayName!
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geofireRef.child(marketTitle).child(username!).removeValue()
        print("removed")
    }
    
    @IBAction func setAQueue(_ sender: Any) {
        self.queMapView.clear()
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let number = Int.random(in: 0 ..< 9999)
        geoFire.setLocation(CLLocation(latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!), forKey: "\(number)")
        
        let username = Auth.auth().currentUser?.displayName!
        let data = [username: true]
        geofireRef.child("\(number)").updateChildValues(data)
        print("joined")
    }
    
    //Location Manager delegates
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!, zoom: 5.0)
        
            //getMarker()
        self.queMapView?.animate(to: camera)
        
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let center = CLLocation(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        let circleQuery = geoFire.query(at: center, withRadius: 0.6)
        var queryHandle = circleQuery.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            print(key!)
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.title = key!
            marker.map = self.queMapView
        })
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "logOut", sender: self)
            print("logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
}

// extension for GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    // tap map marker
     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("didTap marker \(marker.title!)")
        marketTitle = marker.title!
        // tap event handled by delegate
        
        return true
    }
}


