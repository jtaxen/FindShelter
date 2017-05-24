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
	let testPoints: [CLLocationCoordinate2D: (Double, Double)] = [
		CLLocationCoordinate2D(latitude: 69, longitude: 21): (7666089.698, 739639.195),
		
		CLLocationCoordinate2D(latitude: 67, longitude: 17): (7432781.112, 587192.563),
		CLLocationCoordinate2D(latitude: 67, longitude: 19): (7436983.992, 674311.281),
		CLLocationCoordinate2D(latitude: 67, longitude: 21): (7443988.305, 761282.119),
		CLLocationCoordinate2D(latitude: 67, longitude: 23): (7453793.281, 848030.651),
		
		CLLocationCoordinate2D(latitude: 65, longitude: 15): (7208454.582, 500000.000),
		CLLocationCoordinate2D(latitude: 65, longitude: 17): (7209946.446, 594301.012),
		CLLocationCoordinate2D(latitude: 65, longitude: 19): (7214422.171, 688528.118),
		CLLocationCoordinate2D(latitude: 65, longitude: 21): (7221882.137, 782607.157),
		
		CLLocationCoordinate2D(latitude: 63, longitude: 13): (6987164.649, 398706.979),
		CLLocationCoordinate2D(latitude: 63, longitude: 15): (6985589.215, 500000.000),
		CLLocationCoordinate2D(latitude: 63, longitude: 17): (6987164.649, 601293.021),
		CLLocationCoordinate2D(latitude: 63, longitude: 19): (6991891.407, 702513.442),
		
		CLLocationCoordinate2D(latitude: 61, longitude: 13): (6764438.659, 391839.966),
		CLLocationCoordinate2D(latitude: 61, longitude: 15): (6762787.350, 500000.000),
		CLLocationCoordinate2D(latitude: 61, longitude: 17): (6764438.659, 608160.034),
		
		CLLocationCoordinate2D(latitude: 59, longitude: 11): (6546929.751, 270278.433),
		CLLocationCoordinate2D(latitude: 59, longitude: 13): (6541771.139, 385106.329),
		CLLocationCoordinate2D(latitude: 59, longitude: 15): (6540052.017, 500000.000),
		CLLocationCoordinate2D(latitude: 59, longitude: 17): (6541771.139, 614893.671),
		
		CLLocationCoordinate2D(latitude: 57, longitude: 13): (6319164.464, 378514.272),
		CLLocationCoordinate2D(latitude: 57, longitude: 15): (6317385.921, 500000.000),
		CLLocationCoordinate2D(latitude: 57, longitude: 17): (6319164.464, 621485.728),
		CLLocationCoordinate2D(latitude: 57, longitude: 19): (6324501.793, 742911.202),
		
		CLLocationCoordinate2D(latitude: 55, longitude: 13): (6096620.706, 372071.809)
	]
	
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
		
		let accuracy: Double = 0.0003
		
		measure {
			for(key, value) in self.testPoints {
				
				let testResult = self.service.convertUTMToLatLon(north: value.0, east: value.1)
				
				XCTAssertEqualWithAccuracy(testResult.latitude, key.latitude, accuracy: accuracy, "\(abs(testResult.latitude - key.latitude)) for latitude \((key.latitude, key.longitude))")
				XCTAssertEqualWithAccuracy(testResult.longitude, key.longitude, accuracy: accuracy, "\(abs(testResult.longitude - key.longitude)) for longitude \((key.latitude, key.longitude))")
			}
		}
	}
	
	func testLatLonToUTM() {
		
		let accuracy: Double = 1
		
		_ = service.convertLatLonToUTM(point: CLLocationCoordinate2D(latitude: 43.18111111, longitude: -80.38250000))
		
		measure {
			for (key, value) in self.testPoints {
				
				let testResults = self.service.convertLatLonToUTM(point: key)
				
				XCTAssertEqualWithAccuracy(testResults.0, value.0, accuracy: accuracy, "\(abs(testResults.0 - value.0)) for latitude \(value)")
				XCTAssertEqualWithAccuracy(testResults.1, value.1, accuracy: accuracy, "\(abs(testResults.1 - value.1)) for longitude \(value)")
			}
		}
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
	
	func testFootpointLatitude() {
		
		let phi = service.footpointLatitude(4720432.972188876, accuracy: 1e-2)
		XCTAssertEqualWithAccuracy(phi, 0.7438815543289126, accuracy: 1e-2)
	}
}
