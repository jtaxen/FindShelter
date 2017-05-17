//
//  SpatialService.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-17.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//
//  These are implementations of formulas published by
//  Lantmäteriet, The Swedish National Land Survey and
//  can be found here:
//  http://www.lantmateriet.se/globalassets/kartor-och-geografisk-information/gps-och-matning/geodesi/formelsamling/xyz_geodetiska_koord_och_exempel.pdf
//

import Foundation
import CoreLocation

infix operator **: BitwiseShiftPrecedence
func ** (left: Double, right: Double) -> Double {
	return pow(left, right)
}

class SpatialService: SpatialServiceProtocol {
	
	var a        : Double = 6378137 // meters
	var fInverse : Double = 298.257222101
	var f        : Double { get { return 1/fInverse } }
	var e2       : Double { get { return f * ( 2 - f )  } }
	

	
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
	
	func geodeticFromCarthesian(x: Double, y: Double, z: Double) -> (Double, Double, Double) {
		
		// Latitude
	
		let ae2       = a * e2
		let p         = sqrt(x**2 + y**2)
		let theta     = atan(z/(p * sqrt(1 - e2)))
		
		let sin3theta = (sin(theta))**3
		let cos3theta = (cos(theta))**3
		
		let latitude = atan((z + ( ae2 / ( sqrt( 1 - e2 ))) * sin3theta)/( p - ae2 * cos3theta))
		
		// Longitude
		let longitude = atan(y / x)
		
		// Height
		let sin2phi = (sin(latitude))**2
		let N       = a / (sqrt(1 - e2 * sin2phi))
		let height  = p/(cos(latitude)) - N
		
		return (latitude * 180/Double.pi, longitude * 180/Double.pi, height)
	}
	
	func carthesianFromGeodetic(latitude: Double, longitude: Double, height: Double) -> (Double, Double, Double) {
		
		// Convert arguments from degrees to radians
		let lat = latitude * Double.pi / 180.0
		let lon = longitude * Double.pi / 180.0
		
		// Curvature (N)
		let sin2phi = (sin(lat))**2
		let N       = a / (sqrt(1 - e2 * sin2phi))
		
		// x, y, z
		let x = (N + height) * cos(lat) * cos(lon)
		let y = (N + height) * cos(lat) * sin(lon)
		let z = (N * (1 - e2) + height) * sin(lat)
		
		return (x, y, z)
	}
}
