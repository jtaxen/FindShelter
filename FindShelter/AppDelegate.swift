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
		
		window = UIWindow(frame: UIScreen.main.bounds)
		
		var storyboard: UIStoryboard!
		var initialController: UIViewController!
		
		if UserDefaults.standard.value(forKey: "firstTimeOpened") as? Bool == false {
			
			
			storyboard = UIStoryboard(name: "Main", bundle: nil)
			initialController = storyboard.instantiateViewController(withIdentifier: "mainNavigation") as! UINavigationController
		} else {
			UserDefaults.standard.set(false, forKey: "firstTimeOpened")
			storyboard = UIStoryboard(name: "Language", bundle: nil)
			initialController = storyboard.instantiateViewController(withIdentifier: "language") as! ChooseLanguageController
		}
		
		if let language = UserDefaults.standard.string(forKey: "language") {
			
			
		}
		
		window?.rootViewController = initialController
		window?.makeKeyAndVisible()
		
		print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
		
		return true
	}
}

