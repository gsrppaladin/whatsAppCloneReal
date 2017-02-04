//
//  LogInRegisterViewController.swift
//  whatsAppClone
//
//  Created by Sam Greenhill on 2/2/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import UIKit
import Firebase

class LogInRegisterViewController: UIViewController {

    
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    let utilities = Utilities()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInRegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        if ((emailTxtField.text?.characters.count)! < 5) {
            emailTxtField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return
        } else {
            emailTxtField.backgroundColor = UIColor.white
        }
        if ((passwordTxtField.text?.characters.count)! < 5) {
            passwordTxtField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return
        } else {
            passwordTxtField.backgroundColor = UIColor.white
        }
        let email = emailTxtField.text
        let password = passwordTxtField.text
        
        //we can unwrap this here because we did testing of this above.
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                self.utilities.showAlert(title: "Error!", message: error.localizedDescription, vc: self)
                print("SAM: Error in signing in to Firebase \(error.localizedDescription)")
                return
            }
            print("SAM: Successfully Signed in")
        })
        
    }
    
    
    @IBAction func registerBtnPressed(_ sender: Any) {

    }
    
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
    }
    
    
    
    
    
    

}
