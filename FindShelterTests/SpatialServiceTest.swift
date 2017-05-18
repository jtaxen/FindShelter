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
			coordinates = self.service.convertUTMToLatLon(6541771.139,614893.671)
		}
		
		XCTAssertEqualWithAccuracy(coordinates.latitude, 59.0, accuracy: 0.1)
		print("Latitude accuracy is \(abs( coordinates.latitude - 59.0)) degrees")
		XCTAssertEqualWithAccuracy(coordinates.longitude, 17.0, accuracy: 0.01)
		print("Longitude accuracy is \(abs( coordinates.longitude - 17.0)) degrees")
	}
}
