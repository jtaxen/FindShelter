//
//  CLLocationCoordinate2DExtension.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-19.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import KDTree
import MapKit

extension CLLocationCoordinate2D: KDTreePoint, Hashable {
	
	// To conform to Equatable protocol
	public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
	
	// To conform to Hashable protocol
	public var hashValue: Int {
		return self.latitude.hashValue ^ self.longitude.hashValue
	}
	
	// To conform to KFTreePoint protocol
	public static var dimensions: Int = 2
	
	public func kdDimension(_ dimension: Int) -> Double {
		return dimension == 0 ? latitude : longitude
	}
	
	public func squaredDistance(to otherPoint: CLLocationCoordinate2D) -> Double {
		let sLat = SpatialService.shared.radian(self.latitude)
		let sLon = SpatialService.shared.radian(self.longitude)
		let oLat = SpatialService.shared.radian(otherPoint.latitude)
		let oLon = SpatialService.shared.radian(otherPoint.longitude)
		
		let sin2 = { (_ x: Double) -> Double in return 0.5 * ( 1 - cos(2 * x)) }
		
		let deltaPhi = abs(sLat - oLat)
		let deltaLambda = abs(sLon - oLon)
		
		let deltaSigma = 2 * asin( sqrt( sin2(deltaPhi / 2) + cos(sLat) * cos(oLat) * sin2(deltaLambda / 2) ) )
		
		let distance = deltaSigma * SpatialService.shared.meanEarthRadius
		return distance**2
	}
}
