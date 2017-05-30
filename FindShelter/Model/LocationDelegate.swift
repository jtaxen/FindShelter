//
//  LocationDelegate.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDelegate: CLLocationManager {

	internal var currentPosition: CLLocationCoordinate2D!
	
	
	
	override init() {
		super.init()
		delegate = self
		desiredAccuracy = kCLLocationAccuracyBest
		pausesLocationUpdatesAutomatically = false
		allowsBackgroundLocationUpdates = true
		
	}
	
	func getLocation() -> CLLocationCoordinate2D? {
		
		guard CLLocationManager.locationServicesEnabled() else {
			return nil
		}
		startUpdatingLocation()
		return currentPosition
	}
}

extension LocationDelegate: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		currentPosition = manager.location?.coordinate
		print("New position: \(currentPosition.latitude), \t \(currentPosition.longitude)")
		
		
	}
}
