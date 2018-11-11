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

class MapViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var queMapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    

    
   override func viewDidLoad() {
        super.viewDidLoad()
    
    //Location Manager code to fetch current location
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    
    //Map
    queMapView.isMyLocationEnabled = true
    
    }
    
    @IBAction func createQueue(_ sender: Any) {
        createQueue()
    }
    //Location Manager delegates
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!, zoom: 5.0)
        
        self.queMapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func joinQueue(){
            let item = currentEvent
            let itemKey = item.key
            let username = Auth.auth().currentUser?.displayName!
            let messagesDB = Database.database().reference().child("Members/"+itemKey+"/")
            //let userID = Auth.auth().currentUser!.uid
            let data = [username: true]
            messagesDB.updateChildValues(data)
            print("joined")
    }
    
    func leaveQueue(){
        //let userID = Auth.auth().currentUser!.uid
        let username = Auth.auth().currentUser?.displayName!
        let messagesDB = Database.database().reference().child("Members/"+itemKey+"/"+username!+"")
        messagesDB.removeValue()
        print("removed")
    }
    
    //Create Queue
    func createQueue(){
        let eventsDb = Database.database().reference().child("Queues")
        let ref = eventsDb.childByAutoId()
        let eventDict = ["id": ref.childByAutoId().key!,
                         "long": currentLocation?.coordinate.latitude,
                         "lat": currentLocation?.coordinate.longitude] as [String : Any]
        
        ref.setValue(eventDict){
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Queue is active")
            }
        }
        
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



