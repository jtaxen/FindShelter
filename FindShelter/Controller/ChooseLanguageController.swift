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

class ChooseLanguageController: UIViewController {
	
	@IBOutlet weak var label  : UILabel!
	@IBOutlet weak var picker : UIPickerView!
	@IBOutlet weak var button : UIButton!
	
	internal var languages: [String] = ["Svenska", "English", "Deutsch"]
	
	internal var locationManager: CLLocationManager!
	
	override func viewDidLoad() {
		
		locationManager = CLLocationManager()
		locationManager.requestWhenInUseAuthorization()
		UserDefaults.standard.set(CLLocationManager.locationServicesEnabled() , forKey: "locationServicesEnabled")
		
		picker.dataSource = self
		picker.delegate = self
		
		button.addTarget(self, action: #selector(selectLanguage), for: .touchUpInside)
	}
	
	@objc func selectLanguage() {
	
		
		
	}
}
