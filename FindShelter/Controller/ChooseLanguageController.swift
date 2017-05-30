//
//  ChooseLanguageController.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-15.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

/// The view controller which lets the user choose a
/// language when the application starts for the first
/// time.
class ChooseLanguageController: UIViewController {
	
	@IBOutlet weak var label  : UILabel!
	@IBOutlet weak var picker : UIPickerView!
	@IBOutlet weak var button : UIButton!
	
	/// List of the available languages.
	/// - TODO: Move this into a property list.
	internal var languages: [String] = ["Svenska", "English", "Deutsch"]
	
	internal var locationManager: CLLocationManager!
	
	override func viewDidLoad() {
		
		locationManager = CLLocationManager()
		locationManager.requestAlwaysAuthorization()
		UserDefaults.standard.set(CLLocationManager.locationServicesEnabled() , forKey: "locationServicesEnabled")
		
		label.font = UIFont(name: "Futura", size: 17)
		label.textColor = ColorScheme.Title
		
		button.titleLabel?.font = UIFont(name: "Futura", size: 17)
		button.titleLabel?.textColor = ColorScheme.Title
		
		picker.dataSource = self
		picker.delegate = self
		
		button.addTarget(self, action: #selector(selectLanguage), for: .touchUpInside)
	}
	
	@objc func selectLanguage() {
		
		let language = languages[picker.selectedRow(inComponent: 0)]
		UserDefaults.standard.set(language, forKey: "language")
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "mainNavigation")
		show(controller, sender: nil)
		
	}
}
