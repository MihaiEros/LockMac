//
//  AppDelegate.swift
//  LockMac
//
//  Created by Mihai Erős on 30/01/2017.
//  Copyright © 2017 Mihai Erős. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    var session: WCSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
        
        return true
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

    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("[iOS] WCSession is activated.")
        case .inactive:
            print("[iOS] WCSession is inactive.")
        case .notActivated:
            print("[iOS] WCSession is not activated.")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("[iOS] WCSession did become inactive.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("[iOS] WCSession deactivated.")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        // BAD PRACTICE: DO NOT DO THINGS LIKE THESE
        let viewController = ViewController()
        
        if let signout = message["sign_out"] as? String {
            if signout == "true" {
                viewController.signOut()
            }
        } else if let sigin = message["sign_in"] as? String {
            if sigin == "true" {
                viewController.login()
            }
        }
    }
}

