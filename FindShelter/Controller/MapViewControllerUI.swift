//
//  MapViewControllerUI.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

internal extension MapViewController {
	
	func setUpMap() {
		
		map.centerCoordinate = map.userLocation.coordinate 
		map.userLocation.title = NSLocalizedString("Wherever you go, there you are", comment: "n.a.")
		print(MKMapPointForCoordinate(map.centerCoordinate))
	}
}
