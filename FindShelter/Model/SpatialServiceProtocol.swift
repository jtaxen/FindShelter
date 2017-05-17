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
	
	/// Reference ellipsoid parameters
	/// Semi-major axis
	var a: Double { set get }
	/// Flattening and its inverse
	var fInverse: Double { set get }
	var f : Double { get }
	/// First excentricy squared
	var e2: Double { get }
	/// Curvature radius
	var N: Double { get }
	
	func carthesianToGeodetic(_ x: Int, _ y: Int) -> CLLocationCoordinate2D
	
	func geodeticToCarthesian(_ coordinate: CLLocationCoordinate2D) -> (Int, Int)
	
	func convert(fromSWEREF99 coordinate: (Int, Int)) -> CLLocationCoordinate2D
}
