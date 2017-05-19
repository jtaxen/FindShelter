//
//  SpatialServiceTest.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-17.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import XCTest
import CoreLocation
@testable import FindShelter

class SpatialServiceTest: XCTestCase {
	
	var service: SpatialService!
	
	override func setUp() {
		super.setUp()
		service = SpatialService.shared
	}
	
	func testGeodeticFromCarthesian() {
		
		let (lat, lon, height) = service.geodeticFromCarthesian(x: Double(3240036.3696), y: Double(990578.5272), z: Double(5385763.1648))
		
		XCTAssertEqualWithAccuracy(lat, 58.0, accuracy: 0.000001)
		print("Latitude accuracy is \(abs(lat - 58.0)) degrees")
		XCTAssertEqualWithAccuracy(lon, 17.0, accuracy: 0.000001)
		print("Longitude accuracy is \(abs(lon - 17.0)) degrees")
		XCTAssertEqualWithAccuracy(height, 30.0, accuracy: 0.001)
		print("Height accuracy is \(abs(height - 30.0)) m")
	}
	
	func testCarthesianFromGeodetic() {
		
		let targetX = 3240036.3696
		let targetY = 990578.5272
		let targetZ = 5385763.1648
		
		let (x, y, z) = service.carthesianFromGeodetic(latitude: Double(58.0), longitude: Double(17.0), height: Double(30.0))
		
		XCTAssertEqualWithAccuracy(x, targetX, accuracy: 0.001)
		print("x accuracy is \(abs(x - targetX)) m")
		XCTAssertEqualWithAccuracy(y, targetY, accuracy: 0.001)
		print("y accuracy is \(abs(y - targetY)) m")
		XCTAssertEqualWithAccuracy(z, targetZ, accuracy: 0.001)
		print("z accuracy is \(abs(z - targetZ)) m")
	}
	
	func testUTMToLatLon() {
		
		var coordinates: CLLocationCoordinate2D!
		measure {
			coordinates = self.service.convertUTMToLatLon(north: 6541771.139, east: 614893.671)
		}
		
		XCTAssertEqualWithAccuracy(coordinates.latitude, 59.0, accuracy: 0.00001)
		print("Latitude accuracy is \(abs( coordinates.latitude - 59.0)) degrees")
		XCTAssertEqualWithAccuracy(coordinates.longitude, 17.0, accuracy: 0.00001)
		print("Longitude accuracy is \(abs( coordinates.longitude - 17.0)) degrees")
	}
	
	func testNearestElement() {
		
		let stockholm = CLLocationCoordinate2D(latitude: 59.329323, longitude: 18.068581)
		let tallinn   = CLLocationCoordinate2D(latitude: 59.436961, longitude: 24.753575)
		let helsinki  = CLLocationCoordinate2D(latitude: 60.169856, longitude: 24.938379)
		
		let elements = [
			CLLocationCoordinate2D(latitude: 52.520007, longitude: 13.404954), // Berlin
			CLLocationCoordinate2D(latitude: 55.676097, longitude: 12.568337), // Copenhagen
			CLLocationCoordinate2D(latitude: 60.169856, longitude: 24.938379), // Helsinki
			CLLocationCoordinate2D(latitude: 53.904540, longitude: 27.561524), // Minsk
			CLLocationCoordinate2D(latitude: 59.913869, longitude: 10.752245), // Oslo
			CLLocationCoordinate2D(latitude: 50.075538, longitude: 14.437800), // Prague
			CLLocationCoordinate2D(latitude: 56.949649, longitude: 24.105186), // Riga
			CLLocationCoordinate2D(latitude: 59.436961, longitude: 24.753575), // Tallinn
			CLLocationCoordinate2D(latitude: 54.687156, longitude: 25.279651), // Vilnius
			CLLocationCoordinate2D(latitude: 52.229676, longitude: 21.012229)  // Warsaw
		]

		let distance = Distance(elements)
		
		let closest = distance.findNearest(toElement: stockholm)
		
		XCTAssertEqual(closest.latitude, tallinn.latitude)
		XCTAssertEqual(closest.longitude, tallinn.longitude)
		
		let twoClosest = distance.findNearest(2, toElement: stockholm)
		XCTAssertEqual(twoClosest[0].latitude, tallinn.latitude)
		XCTAssertEqual(twoClosest[1].latitude, helsinki.latitude)
	}
}
