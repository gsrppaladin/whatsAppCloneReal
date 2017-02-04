//
//  ViewController.swift
//  whatsAppClone
//
//  Created by Sam Greenhill on 2/1/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //logout-this is so that it logouts so that we can keep testing the login
        //this is going to logout before we check for the user.
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut() //because it says throw it needs a catch
        } catch let signOutError as NSError {
            print("error signing out")
        }
        
        
        if (FIRAuth.auth()?.currentUser == nil) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirebaseLogInViewController")
            //we know vc exists
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }




}

