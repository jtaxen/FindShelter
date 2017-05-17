//
//  SpatialService.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-17.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation

class SpatialService: SpatialServiceProtocol {
	
	var a        : Double = 6378137 // meters
	var fInverse : Double = 298.257222101
	var f        : Double { get { return 1/fInverse } }
	var e2       : Double { get { return f * ( 2 - f )  } }
	var N: Double { get { return a / (sqrt(1 - e2 * sin(0))) } }
	
	
	static let shared = SpatialService()
	
	private init() {}
	
	func carthesianToGeodetic(_ x: Int, _ y: Int) -> CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: 0, longitude: 0)
	}
	
	func geodeticToCarthesian(_ coordinate: CLLocationCoordinate2D) -> (Int, Int) {
		return (0,0)
	}
	
	func convert(fromSWEREF99 coordinate: (Int, Int)) -> CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: 0, longitude: 0)
	}
}

extension SpatialService {
	
	
}
