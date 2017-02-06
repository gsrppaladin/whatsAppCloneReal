//
//  ViewController.swift
//  whatsAppClone
//
//  Created by Sam Greenhill on 2/1/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import UIKit
import Firebase
import UnderKeyboard


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [FIRDataSnapshot]! = [FIRDataSnapshot]()
    
    
    @IBOutlet weak var textField: UITextField!
    
    
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        //logout-this is so that it logouts so that we can keep testing the login
        //this is going to logout before we check for the user.
//        let firebaseAuth = FIRAuth.auth()
//        do {
//            try firebaseAuth?.signOut() //because it says throw it needs a catch
//        } catch let signOutError as NSError {
//            print("error signing out")
//        }
        
        
        if (FIRAuth.auth()?.currentUser == nil) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirebaseLogInViewController")
            //we know vc exists
            self.navigationController?.present(vc!, animated: true, completion: nil)
        }
    }
    

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    let keyboardObserver = UnderKeyboardObserver()
    let underKeyboardLayoutConstraint = UnderKeyboardLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardObserver.start()
        tableView.dataSource = self
        tableView.delegate = self
        self.textField.delegate = self
        
        keyboardObserver.willAnimateKeyboard = { height in
        self.bottomLayoutConstraint.constant = height
        }
        
        
        keyboardObserver.animateKeyboard = { height in
            self.view.layoutIfNeeded()
        
        
        }
        


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("ended editing")
        self.view.endEditing(true)
        return true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let messageSnap: FIRDataSnapshot = self.messages[indexPath.row]
        let message = messageSnap.value as! Dictionary<String, String>
        let mText = message["text"] as String!
        cell.textLabel?.text = mText
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    



}

