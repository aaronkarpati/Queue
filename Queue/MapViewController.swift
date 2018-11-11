//
//  MapViewController.swift
//  Queue
//
//  Created by Áron Kárpáti on 2018. 11. 10..
//  Copyright © 2018. Áron Kárpáti. All rights reserved.
//

import UIKit
import GoogleMaps
import GeoFire
import Firebase
import FirebaseDatabase


class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var joinQ: UIButton!
    @IBOutlet weak var leaveQ: UIButton!
    @IBOutlet weak var createQ: UIButton!
    @IBOutlet weak var logoutQ: UIButton!
    @IBOutlet weak var queMapView: GMSMapView!
    
    var marketTitle = String()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let geofireRef = Database.database().reference().child("Queues")
    let username = Auth.auth().currentUser?.displayName!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set design for buttons and view
        setViewStyle(cell: queMapView)
        setButtonStyle(cell: joinQ)
        setButtonStyle(cell: leaveQ)
        setButtonStyle(cell: createQ)
        setButtonStyle(cell: logoutQ)
        
        //Location Manager code to fetch current location and delegate mapView
        queMapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        //Navbar-Opacity
        self.navigationController!.navigationBar.isHidden = true
        
        //Button-Opacity
        joinQ.isHidden = true
        leaveQ.isHidden = true
        createQ.isHidden = false
        
        //SetupMap
        queMapView.isMyLocationEnabled = true
        
    }
    
    
    //Create a new Queue
    @IBAction func setAQueue(_ sender: Any) {
        self.queMapView.clear()
        
        let number = Int.random(in: 0 ..< 9999) //--> randomid
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let data = [username: true]
       
        geoFire.setLocation(CLLocation(latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!), forKey: "\(number)")
        
        geofireRef.child("\(number)").updateChildValues(data)
        print("joined")
    }
    
    //Get my current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!, zoom: 5.0)
        
        self.queMapView?.animate(to: camera)
        putMarkersOnTheMap()
        
        //Stop updating
        self.locationManager.stopUpdatingLocation()
        
    }
    
    //Setup markers on the map
    func putMarkersOnTheMap(){
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let center = CLLocation(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        
        let circleQuery = geoFire.query(at: center, withRadius: 0.6) //600m radius
        
        circleQuery.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.title = key!
            marker.map = self.queMapView
        })
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
    
    @IBAction func joinQ(_ sender: Any) {
        let data = [username: true]
        geofireRef.child(marketTitle).updateChildValues(data)
        print("joined")
        hiddenViews(join: true, leave: true, create: false)
        
    }
    
    @IBAction func leaveQ(_ sender: Any) {
        geofireRef.child(marketTitle).child(username!).removeValue()
        print("removed")
        hiddenViews(join: true, leave: true, create: false)
        
    }
    
    func hiddenViews(join: Bool, leave: Bool, create: Bool){
        joinQ.isHidden = join
        leaveQ.isHidden = leave
        createQ.isHidden = create
    }
}

func setViewStyle(cell: UIView){
    
    cell.layer.cornerRadius = 5.0
    cell.layer.borderWidth = 1.0
    cell.layer.borderColor = UIColor.clear.cgColor
    cell.layer.masksToBounds = true;
    
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
    cell.layer.shadowRadius = 2.0
    cell.layer.shadowOpacity = 0.5
    cell.layer.masksToBounds = false;
    cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.layer.cornerRadius).cgPath
}

func setButtonStyle(cell: UIButton){
    
    cell.layer.cornerRadius = 5.0
    cell.layer.borderWidth = 1.0
    cell.layer.borderColor = UIColor.clear.cgColor
    cell.layer.masksToBounds = true;
    
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
    cell.layer.shadowRadius = 2.0
    cell.layer.shadowOpacity = 0.5
    cell.layer.masksToBounds = false;
    cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.layer.cornerRadius).cgPath
}
// extension for GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    // tap map marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("didTap marker \(marker.title!)")
        hiddenViews(join: false, leave: false, create: true)
        marketTitle = marker.title!
        // tap event handled by delegate
        
        return true
    }
}



