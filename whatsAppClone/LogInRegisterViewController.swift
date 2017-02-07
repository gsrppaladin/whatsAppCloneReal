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
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            
        }
    }
    
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

        if (!checkInput()) {
            return
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
        if (!checkInput()) {
            return
        }

        //would normally do this in registration
        let alert = UIAlertController(title: "Register", message: "Please confirm password...", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            let passConfirm = alert.textFields![0] as UITextField
            if (passConfirm.text!.isEqual(self.passwordTxtField.text!)) {
                //Reg begins
        
            let email = self.emailTxtField.text
            let password = self.passwordTxtField.text
        
                FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
                    if let error = error {
                        self.utilities.showAlert(title: "Error", message: error.localizedDescription, vc: self)
                    return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else {
                self.utilities.showAlert(title: "Error", message: "Passwords not the same!", vc: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        if emailTxtField.text!.isEmpty {
            let email = self.emailTxtField.text
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: email!, completion: { (error) in
                if let error = error {
                    self.utilities.showAlert(title: "Error", message: error.localizedDescription, vc: self)
                    return
                }
                self.utilities.showAlert(title: "Success!", message: "Please check you email address", vc: self)
            })
        }
    }
    
    
    func checkInput() -> Bool {
        if ((emailTxtField.text?.characters.count)! < 5) {
            emailTxtField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        } else {
            emailTxtField.backgroundColor = UIColor.white
        }
        if ((passwordTxtField.text?.characters.count)! < 5) {
            passwordTxtField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        } else {
            passwordTxtField.backgroundColor = UIColor.white
        }
        return true
    }
    
    
    

}
