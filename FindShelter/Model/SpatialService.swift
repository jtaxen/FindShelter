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
//  The refined method are based on the following papers:
//  http://krcmar.ca/sites/default/files/Coordinate%20Transformations-%20UTM%20to%20Geographic_0.pdf
//  http://earth-info.nga.mil/GandG/publications/tm8358.2/TM8358_2.pdf
//

import Foundation
import CoreLocation

/// Use ** as exponentiation operator
infix operator **: BitwiseShiftPrecedence
func ** (left: Double, right: Double) -> Double {
	return pow(left, right)
}

/**
This class contains methods for converting between the Universal Transverse Mercator coordinate 
system and WGS 84.
*/
class SpatialService {
	
	/// Semi-major axis
	public var a        : Double = 6378137 // meters
	/// Inverse flattening
	public var fInverse : Double = 298.257222101
	/// Central scale factor
	public var k0       : Double = 0.9996
	
	internal var f    : Double { get { return 1/fInverse } }
	internal var e2   : Double { get { return f * ( 2 - f ) } }
	internal var b    : Double { get { return a * ( 1 - f) } }
	internal var n    : Double { get { return f / ( 2 - f ) } }
	internal var B0   : Double { get { return b * ( 1 + n + 5 * (n**2) / 4 + 5 * (n**3) / 4 ) } }
	internal var mp   : Double { get { return Double.pi * B0 / 2 } }
	internal var A0   : Double { get { return 1 + e2 * ( 3/4 + e2 * ( 45/64 + e2 * ( 175/256 + e2 * ( 11025/16384 + e2 * ( 43659/65536 + e2 * 693693/1048576))))) } }
	internal var aHat : Double { get { return a * ( 1 + (n**2) / 4 + (n**4) / 64) } }
	
	/// False easting
	public let falseEasting: Double = 500000.0
	/// False northing
	public let falseNorthing: Double = 0.0
	
	/// UTM zone
	public internal(set) var zone : Int = 33
	public var midmeridian       : Double { get { return Double(zone * 6 - 183) } }
	
	internal var meanEarthRadius: Double { get { return ( 2 * a + b) / 3 } }
	
	/// Helper closures to convert angles between radians and degrees
	internal var radian = { (_ degree: Double) -> Double in
		return Double.pi * degree / 180
	}
	
	internal var degree = { (_ radian: Double) -> Double in
		return 180 * radian / Double.pi
	}
	
	/// Singleton
	static let shared = SpatialService()
	private init() {}
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
	
	func deprecatedConvertUTMToLatLon(north x: Double, east y: Double) -> CLLocationCoordinate2D {
		
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
}
