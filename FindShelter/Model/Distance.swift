//
//  Distance.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-18.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import KDTree
import MapKit

extension CLLocationCoordinate2D: KDTreePoint {
	
	// To conform to Equatable protocol
	public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
	
	public static var dimensions: Int = 2
	
	public func kdDimension(_ dimension: Int) -> Double {
		return dimension == 0 ? latitude : longitude
	}
	
	public func squaredDistance(to otherPoint: CLLocationCoordinate2D) -> Double {
		
		let deltaPhi = abs(self.latitude - otherPoint.latitude)
		let deltaLambda = abs(self.longitude - otherPoint.longitude)
		
		let deltaSigma = 2 * asin( sqrt( (sin(deltaPhi / 2))**2 + cos(self.latitude) * cos(otherPoint.latitude) * ( sin(deltaLambda / 2))**2) )
		
		let distance = deltaSigma * SpatialService.shared.meanEarthRadius
		return distance**2
	}
}

class Distance {
	

	
}
