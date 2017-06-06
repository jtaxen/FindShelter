//
//  GISParametersTests.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import XCTest
@testable import FindShelter

class GISParametersTests: XCTestCase {
	
	let GISParams = GISParameters.shared

	func testMakeParameters() {
	
		let parameters = GISParams.makeParameters()
		
		XCTAssertEqual(parameters[GISParameters.ParameterKeys.F] as! String, "json")
	}
	
	func testMakeParametersWithSearchText() {
	
		let searchString = "Hallenborgs gata"
		let parameters = GISParams.makeParameters(find: searchString)
		
		XCTAssertEqual(parameters[GISParameters.ParameterKeys.SearchText] as! String, searchString)
		
	}
}
