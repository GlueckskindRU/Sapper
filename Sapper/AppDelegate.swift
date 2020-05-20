//
//  AppDelegate.swift
//  Sapper
//
//  Created by Yuri Ivashin on 09.04.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let mainVC = Bundle.main.loadNibNamed(String(describing: MainViewController.self), owner: nil, options: nil)?.first as? MainViewController {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = .lightGray
            
            window?.rootViewController = mainVC
            window?.makeKeyAndVisible()
        }
        
        return true
    }


}

