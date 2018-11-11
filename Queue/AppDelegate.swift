//
//  AppDelegate.swift
//  Queue
//
//  Created by Áron Kárpáti on 2018. 11. 10..
//  Copyright © 2018. Áron Kárpáti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    

    var window: UIWindow?
    var ref: DatabaseReference?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyDCpe5V5gOHfkcaK2x4tqMFuONNAbKl9HM")
        GMSPlacesClient.provideAPIKey("AIzaSyDCpe5V5gOHfkcaK2x4tqMFuONNAbKl9HM")
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if error != nil {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                // ...
                return
            }
            
            print("Google Authentification Success")
            
  
                self.ref = Database.database().reference()
                let user = Auth.auth().currentUser
                
                self.ref!.child("Users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let snapshot = snapshot.value as? NSDictionary
                    
                    if(snapshot == nil){
                        self.ref!.child("Users").child(user!.uid).child("email").setValue(user?.email)
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController")
                    self.window?.rootViewController = initialViewController
                    
                })
            
    
            // User is signed in
            //...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

