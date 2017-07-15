//
//  ViewController.swift
//  LockMac
//
//  Created by Mihai Erős on 30/01/2017.
//  Copyright © 2017 Mihai Erős. All rights reserved.
//

import UIKit
import NMSSH

class ViewController: UIViewController {
    
    // Constants
//    <#ERROR#>// FILL IN WITH YOUR OWN VALUES HERE
    let kUsername = "mihaieros"
    let kPassword = "test1234"
    let kHost = "192.168.0.227"
    
    // Properties
    var isAccessGranted: Bool = false
    var session: NMSSHSession?
    
    // Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var sleepButton: UIButton!
    
    // MARK: - NMSSH connection - establishes a connection with your Mac
    
    private func connect() {
        // create the NMSSHSession
        session = NMSSHSession()
        session = NMSSHSession.connect(toHost: kHost, withUsername: kUsername)
        if let session = session {
            if session.isConnected {
                // authenticate by password
                session.authenticate(byPassword: kPassword)
                if session.isAuthorized {
                    self.isAccessGranted = true
                } else {
                    self.isAccessGranted = false
                }
            }
        }
    }
    
    // MARK: - Sleep method implemented using SSH command
    
    public func signOut() {
        connect()
        
        // ssh command which puts a Mac to sleep
        let sshCommand = "osascript -e 'tell application \"System Events\" to sleep'"
        // timeout defined in seconds
        let timeout: NSNumber = 30
        
        var error: NSError?
        guard let session = session else {
            // session is nil
            print("No session has been initialized.")
            return
        }
        
        if isAccessGranted {
            let response = session.channel.execute(sshCommand, error: &error, timeout: timeout)
            
            if let response = response {
                // if we have a response, it will be printed
                print(response)
            } else if error != nil {
                // if we have an error, the localizedDescription will be printed
                print(error?.localizedDescription ?? "No error message was provided.")
            }
            
            // either way we have to close the connection
            session.disconnect()
        } else if !isAccessGranted {
            // access is not granted
            print("Check your credentials, something is worng.")
        }
    }
    
    // MARK: - Login method implemented using SSH command
    
    public func login() {
        connect()
        
        // wake up your Mac's screen
        wakeScreen()
        
//        <#ERROR#>// IF YOU HAVE A DIFFERENT PASSWORD, YOU NEED TO BUILD A BIGGER ARRAY HERE
        
        // Virtual Keyboard ANSI Standard US keyboard
        // for letters t, e, s, t, 1, 2, 3, 4 - ordered exactly as are written here
        let keyCodes = [17, 14, 1, 17, 18, 19, 20, 21]
        
        // timeout defined in seconds
        let timeout: NSNumber = 30
        
        var error: NSError?
        guard let session = session else {
            // session is nil
            print("No session has been initialized.")
            return
        }
        
        if isAccessGranted {
            for index in 0..<keyCodes.count {
                // ssh command for keystroke
                let sshCommand = "osascript -e 'tell application \"System Events\" to key code \(keyCodes[index])'"
                let response = session.channel.execute(sshCommand, error: &error, timeout: timeout)
                
                if let response = response {
                    // if we have a response, it will be printed
                    print(response)
                } else if error != nil {
                    // if we have an error, the localizedDescription will be printed
                    print(error?.localizedDescription ?? "No error message was provided.")
                }
            }
        } else if !isAccessGranted {
            // access is not granted
            print("Check your credentials (SSH connection), something is worng.")
        }
        
        // press the enter key
        pressEnter()
        
        // you should finally close the connection
        session.disconnect()
    }
    
    // MARK - Press ENTER key to wake up the Mac
    
    private func pressEnter() {
        // ssh command which hits the return key on the keyboard
        let sshCommand = "osascript -e 'tell application \"System Events\" to key code 36'"
        // timeout defined in seconds
        let timeout: NSNumber = 30
        
        var error: NSError?
        guard let session = session else {
            // session is nil
            print("No session has been initialized.")
            return
        }
        
        if isAccessGranted {
            let response = session.channel.execute(sshCommand, error: &error, timeout: timeout)
            if let response = response {
                // if we have a response, it will be printed
                print(response)
            } else if error != nil {
                // if we have an error, the localizedDescription will be printed
                print(error?.localizedDescription ?? "No error message was provided.")
            }
        } else if !isAccessGranted {
            // access is not granted
            print("Check your press return key ssh command, something is worng.")
        }
    }
    
    private func wakeScreen() {
        // ssh command which hits the return key on the keyboard
        let sshCommand = "caffeinate -u -t 2"
        // timeout defined in seconds
        let timeout: NSNumber = 30
        
        var error: NSError?
        guard let session = session else {
            // session is nil
            print("No session has been initialized.")
            return
        }
        
        if isAccessGranted {
            let response = session.channel.execute(sshCommand, error: &error, timeout: timeout)
            if let response = response {
                // if we have a response, it will be printed
                print(response)
            } else if error != nil {
                // if we have an error, the localizedDescription will be printed
                print(error?.localizedDescription ?? "No error message was provided.")
            }
        } else if !isAccessGranted {
            // access is not granted
            print("Check your code, something is worng.")
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        // enter the credentials for your account
        login()
    }
    
    @IBAction func didTapSleepButton(_ sender: Any) {
        // put your Mac to sleep
        signOut()
    }
}

