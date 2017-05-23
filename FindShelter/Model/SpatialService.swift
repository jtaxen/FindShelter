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
//  https://www.lantmateriet.se/globalassets/kartor-och-geografisk-information/gps-och-matning/geodesi/formelsamling/gauss_conformal_projection.pdf
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
	var k0       : Double = 0.9996
	var f        : Double { get { return 1/fInverse } }
	var e2       : Double { get { return f * ( 2 - f )  } }
	var b        : Double { get { return a * ( 1 - f) } }
	var n        : Double { get { return f / ( 2 - f ) } }
	var B0       : Double { get { return b * ( 1 + n + 5 * (n**2) / 4 + 5 * (n**3) / 4 ) }}
	var mp       : Double { get { return Double.pi * B0 / 2 } }
	
	let falseEasting: Double = 500000.0
	let falseNorthing: Double = 0.0
	var aHat: Double { get { return a * ( 1 + (n**2) / 4 + (n**4) / 64) } }
	var zone: Int = 33
	var midmeridian: Double { get { return Double(zone * 6 - 183) } }
	var meanEarthRadius: Double { get { return ( 2 * a + b) / 3 } }
	
	var radian = { (_ degree: Double) -> Double in
		return Double.pi * degree / 180
	}
	
	var degree = { (_ radian: Double) -> Double in
		return 180 * radian / Double.pi
	}
	
	
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
		
		let latitude  = atan((z + ( ae2 / ( sqrt( 1 - e2 ))) * sin3theta)/( p - ae2 * cos3theta))
		
		// Longitude
		let longitude = atan(y / x)
		
		// Height
		let sin2phi   = (sin(latitude))**2
		let N         = a / (sqrt(1 - e2 * sin2phi))
		let height    = p/(cos(latitude)) - N
		
		return (latitude * 180/Double.pi, longitude * 180/Double.pi, height)
	}
	
	func carthesianFromGeodetic(latitude: Double, longitude: Double, height: Double) -> (Double, Double, Double) {
		
		// Convert arguments from degrees to radians
		let lat = radian(latitude)
		let lon = radian(longitude)
		
		// Curvature (N)
		let sin2phi = (sin(lat))**2
		let N       = a / (sqrt(1 - e2 * sin2phi))
		
		// x, y, z
		let x = (N + height) * cos(lat) * cos(lon)
		let y = (N + height) * cos(lat) * sin(lon)
		let z = (N * (1 - e2) + height) * sin(lat)
		
		return (x, y, z)
	}
	
	func convertUTMToLatLon(north x: Double, east y: Double) -> CLLocationCoordinate2D {
		
		let xi = ( x - falseNorthing ) / ( k0 * aHat )
		let eta = ( y - falseEasting) / ( k0 * aHat )
		
		let delta1 = n / 2 - 2 * (n**2) / 3 + 37 * (n**3) / 96 - (n**4) / 360
		let delta2 = (n**2) / 48 + (n**3) / 15 - 437 * (n**4) / 1440
		let delta3 = 17 * (n**3) / 480 - 37 * (n**4) / 840
		let delta4 = 4397 * (n**4) / 161280
		
		let xiPrime  = xi  - delta1 * sin(2 * xi) * cosh(2 * eta) - delta2 * sin( 4 * xi ) * cosh(4 * eta) - delta3 * sin(6 * xi) * cosh(6 * eta) - delta4 * sin( 8 * xi ) * cosh( 8 * eta)
		let etaPrime = eta - delta1 * cos(2 * xi) * sinh(2 * eta) - delta2 * cos( 4 * xi ) * sinh(4 * eta) - delta3 * cos(6 * xi) * sinh(6 * eta) - delta4 * cos( 8 * xi ) * sinh( 8 * eta)
		
		let phistar = asin( sin(xiPrime) / cosh(etaPrime) ) // Conformal latitude
		let differenceInLongitude = atan( sinh(etaPrime) / cos(xiPrime) )
		
		let longitude = radian(midmeridian) + differenceInLongitude
		
		let Astar = e2 + e2**2 + e2**3 + e2**4
		let Bstar = -(7 * (e2**2) + 17 * (e2**3) + 30 * (e2**4)) / 6
		let Cstar = (224 * (e2**3) + 889 * (e2**4)) / 120
		let Dstar = -4279 * (e2**4) / 1260
		
		let latitude = phistar + sin(phistar) * cos(phistar) * ( Astar + Bstar * ((sin(phistar))**2) + Cstar * ((sin(phistar))**4) + Dstar * ((sin(phistar))**6))
		
		return CLLocationCoordinate2D(latitude: degree(latitude), longitude: degree(longitude))
	}
	
	func convertUTMToLatLong(north x: Double, east y: Double) -> CLLocationCoordinate2D {
		
		return CLLocationCoordinate2D(latitude: 0, longitude: 0)
	}
}
