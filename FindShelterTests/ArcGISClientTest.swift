//
//  ArcGISClientTest.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-15.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import XCTest
@testable import FindShelter

class ArcGISClientTest: XCTestCase {
    
	var client: ArcGISClient!
	var url: URL!
	var parameters: [String: AnyObject]!
	
	override func setUp() {
		client = ArcGISClient()
		url = GISParameters.URL(.find)!
		parameters = GISParameters.shared.makeParameters(find: "Hallenborgs gata")
	}
	
	func testAPIRequest() {
		
		let expectation = XCTestExpectation(description: "The API request was successfull")
		client.makeAPIRequest(url: url, parameters: parameters) { json in
			expectation.fulfill()
		}
		
	}
	
	
    
}
