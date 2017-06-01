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

/**
In order to perform kd-tree nearest-neighbourgh-searches on `CLLocationCoordinate2D`
objects with the `KDTree` framework, the `CLLocationCoordinate2D` class must be
extended to conform with the `Equatable` and `KDTreePoint protocols`. It is also
extended to conform with the `Hashable`protocol so that it can be used as a key
in dictionaries.
*/
extension CLLocationCoordinate2D: KDTreePoint, Hashable {
	
	/// This establishes an equal relation in order for it to conform with the `Equal`protocol.
	public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
	
	/// Hashvalue definition to make the class conform to the `Hashable` protocol.
	public var hashValue: Int {
		return self.latitude.hashValue ^ self.longitude.hashValue
	}
	
	/// The number of dimensions is in this implementation always two dimensions.
	public static var dimensions: Int = 2
	
	/// The first dimension is the latitude and the second is the longitude.
	public func kdDimension(_ dimension: Int) -> Double {
		return dimension == 0 ? latitude : longitude
	}
	
	/// This is a first-approximation distance function that assumes that the globe is a sphere. For more exact results, the next step is to take into regard that the globe is an ellipsoid, but for this application, this function is good enough.
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
