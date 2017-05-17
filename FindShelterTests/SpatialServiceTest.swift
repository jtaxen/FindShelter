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
	
	override func setUp() {
		let spat =  
	}
	
	func testCoordinateFromGeodetic() {
		
		let(lat, lon, height) = service.geodeticToCarthesian(x: Double(3240036.3696), y: Double(990578.5272), z: Double(5385763.1648))
		
		XCTAssertEqualWithAccuracy(lat, 58.0, accuracy: 1.0, "Latitude accuracy is \(abs(lat - 58.0)) m")
		XCTAssertEqualWithAccuracy(lon, 17.0, accuracy: 1.0, "Longitude accuracy is \(abs(lon - 17.0)) m")
		XCTAssertEqualWithAccuracy(height, 30.0, accuracy: 1.0, "Height accuracy is \(abs(height - 30.0)) m")
	}
	
}
