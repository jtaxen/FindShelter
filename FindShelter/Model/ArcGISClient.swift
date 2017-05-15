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

class ArcGISClient {

	func makeAPIRequest(url: URL, parameters: [String: AnyObject], completionHandler: @escaping (_ json: JSON) -> Void) {
		print("Sending request")
		request(url.absoluteString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (dataResponse) in
			
			let duration = Int(dataResponse.timeline.requestDuration * 1000)
			print("Response returned in \(duration) ms")
			
			guard let response = dataResponse.response else {
				return 
			}
			
			guard response.statusCode >= 200 && response.statusCode < 299 else {
				debugPrint(ServerError.badServerResponse(response.statusCode))
				return
			}
			
			let json = JSON(dataResponse.data as Any)
			completionHandler(json)
		}
	}
}

