//
//  DistanceTest.swift
//  FindShelter
//
//  Created by Jacob Taxén on 2017-05-18.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import XCTest
import CoreLocation
@testable import FindShelter

class DistanceTest: XCTestCase {
    
    func testShortestDistanceSquared() {
        
        let point1 = CLLocationCoordinate2D(latitude: 60.0, longitude: 17.0)
        let point2 = CLLocationCoordinate2D(latitude: 56.0, longitude: 13.0)
        
        let distance = point1.squaredDistance(to: point2)
        XCTAssertEqualWithAccuracy(sqrt(distance), 503200 , accuracy: 30)
        print("Distance accuracy is \(abs(sqrt(distance) - 480300))")
    }
    
}
