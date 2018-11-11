//
//  LoginViewController.swift
//  Queue
//
//  Created by Áron Kárpáti on 2018. 11. 10..
//  Copyright © 2018. Áron Kárpáti. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToMap", sender: self)
            print(Auth.auth().currentUser?.email!)
        }
        
        
        //GIDSignIn.sharedInstance().signIn()
        
                
        
        // Do any additional setup after loading the view.
    }
    

}
