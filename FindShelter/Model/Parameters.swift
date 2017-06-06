//
//  Parameters.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol Parameters {
	
	func makeParameters() -> [String: AnyObject]
	
	func makeParameters(find searchText: String) -> [String: AnyObject]
	
	func makeParameters(identify point: CLLocationCoordinate2D, inRadius radius: Int, mapExtent: MKCoordinateRegion) -> [String: AnyObject]
	
}
