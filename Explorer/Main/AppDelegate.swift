//
//  AppDelegate.swift
//  Explorer
//
//  Created by Zagahr on 16.08.18.
//  Copyright © 2018 Zagahr. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        let _ = RCValues.shared
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        appCoordinator = AppCoordinator(window: window)
        
        appCoordinator.start()
                        
        return true
    }
}
