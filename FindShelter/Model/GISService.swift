//
//  GISService.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-11.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON

class GISService {
	
	func alamo() {
		
		let parameters: Parameters = [
		"searchText":"kämnärsvägen",
		"contains": true,
		"layers": 0,
		"returnGeometry": true,
		"f": "json",
		"spatialReference": 3006
		]
		
		request("https://gis-services.metria.se/arcgis/rest/services/msb/InspireMSB_Skyddsrum/MapServer/find", parameters: parameters).responseJSON { response in
			
			print(response.response!)
			
			guard let jsonResponse = response.value else {
				print("Booo")
				return
			}
			
			let json = JSON(jsonResponse)
			
			recursiveDigger(json: json)
			
		}
		
		func recursiveDigger(json: JSON, tabs: String = "") {
			var sub = ""
			if json.count > 1 {
				sub += "\(json.first!.1)"
			}
			
			for (key, subJson): (String, JSON) in json {
				print(tabs + key + ": " + sub)
				recursiveDigger(json: subJson, tabs: tabs + "\t")
			}
		}
	}
	
}
