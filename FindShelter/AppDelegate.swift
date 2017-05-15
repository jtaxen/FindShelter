//
//  AppDelegate.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-10.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Check if it is the first time the application is opened
		if UserDefaults.standard.value(forKey: "firstTimeOpened") as? Bool != false {
			UserDefaults.standard.set(false, forKey: "firstTimeOpened")
			print("First time")
		} else {
			print("Not the first time")
		}
		
		return true
	}
}

