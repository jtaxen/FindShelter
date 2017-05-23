//
//  SpatialServiceProtocol.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-17.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation

protocol SpatialServiceProtocol {
	
	func carthesianToGeodetic(_ x: Int, _ y: Int) -> CLLocationCoordinate2D
	
	func geodeticToCarthesian(_ coordinate: CLLocationCoordinate2D) -> (Int, Int)
	
	func convert(fromSWEREF99 coordinate: (Int, Int)) -> CLLocationCoordinate2D
	
	/// UTM to latitude/longitude
	func convertUTMToLatLon(north x: Double, east y: Double) -> CLLocationCoordinate2D
}
