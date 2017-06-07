//
//  AppDelegate.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-10.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
        window = UIWindow(frame: UIScreen.main.bounds)
        
        var storyboard: UIStoryboard!
        var initialController: UIViewController!
		
		if true {
			
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            initialController = storyboard.instantiateViewController(withIdentifier: "mainNavigation") as! UINavigationController
        }
		
		window?.rootViewController = initialController
		window?.makeKeyAndVisible()
		
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
}

