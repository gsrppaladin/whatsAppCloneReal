//
//  MainVC.swift
//  whatsAppClone
//
//  Created by Sam Greenhill on 2/1/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import UIKit
import Firebase
import UnderKeyboard
import FirebaseStorage




class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [FIRDataSnapshot]! = []
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
 
    var storageRef: FIRStorageReference!
    
   
    
    @IBOutlet weak var textField: UITextField!
    
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
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
        
        configureDatabase()
        configureStorage()
        
        //going to register for a notification:
        //add an observer, and it is going to fire whenever the keyboard is used or hidden
    
        //observer is the current instance of the class
        //
        keyboardObserver.willAnimateKeyboard = { height in
        self.bottomLayoutConstraint.constant = height
        }
        keyboardObserver.animateKeyboard = { height in
            self.view.layoutIfNeeded()
        }
    }
    
    
    func sendMessage(withData data: [String: String]) {
        var packet = data
        packet[Constants.messageFields.name] = AppState.sharedInstance.displayName
        if let photoUrl = AppState.sharedInstance.photoURL {
            packet[Constants.messageFields.photoURL] = photoUrl.absoluteString
        }
        //this is sending the data
        self.ref.child("messages").childByAutoId().setValue(packet)
    }

    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
   
        guard let text = textField.text else { return true }
        textField.text = ""
        view.endEditing(true)
        let data = [Constants.messageFields.text: text]
        sendMessage(withData: data)
        return true
    }

    //we have created an observer, and we have to remove it if we are shutting everything down. we create a deinitializer which is fired before everything gets cleared.
    deinit {
        self.ref.child("messages").removeObserver(withHandle: _refHandle)
    }
    
    
    
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        //listen for new messages that are coming in
        
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.messages.count - 1, section: 0)], with: .automatic)
        })
            
        
    }
    
    func configureStorage() {
        let storageUrl = FIRApp.defaultApp()?.options.storageBucket
        storageRef = FIRStorage.storage().reference(forURL: "gs://" + storageUrl!)
    }
    
    
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let messageSnap: FIRDataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnap.value as? [String:String] else { return cell }
        let mtext = message[Constants.messageFields.text] ?? ""
        cell.textLabel?.text =  "Message: " + mtext

        
        return cell
    }
    


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            messages.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    
    
    
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

