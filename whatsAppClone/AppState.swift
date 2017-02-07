//
//  AppState.swift
//  whatsAppClone
//
//  Created by Sam Greenhill on 2/6/17.
//  Copyright © 2017 simplyAmazingMachines. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
}
