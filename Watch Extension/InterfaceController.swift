//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Mihai Erős on 31/01/2017.
//  Copyright © 2017 Mihai Erős. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - IBActions

    @IBAction func didTapLockButton() {
        WKInterfaceDevice.current().play(.click)
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        extensionDelegate.signout()
    }
    
    @IBAction func didTapUnlockButton() {
        WKInterfaceDevice.current().play(.click)
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        extensionDelegate.login()
    }
}
