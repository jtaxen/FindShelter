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
import UIKit

internal extension MapViewController {
	
	func setUpMap() {
		
		map.userTrackingMode = .follow
		map.region = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
	}
	
	func setUpInfoBar() {
		
		infoLabel.text = NSLocalizedString("Waiting for position...", comment: "Waiting for position")
		infoLabel.font = UIFont(name: "Futura", size: 17)
	}
}
