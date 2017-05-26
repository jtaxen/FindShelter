//
//  ArcGISClient.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper

/// ArcGISClient contains the methods for making requests
/// to the server where the information about the shelters
/// is stored.
public class ArcGISClient {
	
	/**
	The main function which, given parameters that conform to the ArcGIS 
	searchText method, sends a request to the server. The response is
	assumed to be parsable as an ArcGISResult object. Documentation
	on how to make requests and which parameters to use can be found here:
	[msb/InspireMSB_Skyddsrum (MapServer)](https://gis-services.metria.se/arcgis/rest/services/msb/InspireMSB_Skyddsrum/MapServer)
	
	- Parameter url: The URL to the server.
	- Parameter parameters: Dictionary containing query key strings and respective value.
	- Parameter completionHandler: Handles the results.
	- Parameter json: The request results in a list of ShelterObject objects.
	*/
	func makeAPIRequest(url: URL, parameters: [String: AnyObject], completionHandler: @escaping (_ json: [ShelterObject]?) -> Void) {
		print("Sending request")
		request(url.absoluteString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseObject { ( response: DataResponse<ArcGISResults>) in
			print(url.absoluteString)
			print(parameters)
			let duration = Int(response.timeline.requestDuration * 1000)
			print("Response returned in \(duration) ms")
			
			guard let code = response.response?.statusCode else {
				debugPrint(Errors.new(code: 199, comment: "No status code returned"))
				completionHandler(nil)
				return
			}
			
			guard code >= 200 && code <= 299 else {
				debugPrint(Errors.new(code: 100 + code % 100, comment: "Server returned status code \(code)"))
				completionHandler(nil)
				return
			}
			
			guard let shelterList = response.result.value?.results else {
				debugPrint(Errors.new(code: 110))
				completionHandler(nil)
				return
			}
			
			completionHandler(shelterList)
		}
	}
}

