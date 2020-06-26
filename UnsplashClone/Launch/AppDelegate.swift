//
//  AppDelegate.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/25/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LibManager.shared.settingThirdLib()
        return true
    }



}

