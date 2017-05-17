//
//  ResponseHandler.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import CoreLocation

public class ResponseHandler: ResponseHandlerProtocol {
	
	public static let shared = ResponseHandler()
	
	private var locationCoordinateList: [CLLocationCoordinate2D]!
	
	private init() {}
	
	func coordinates(for shelter: ShelterObject) -> CLLocationCoordinate2D? {
		
		var locationCoordinate: CLLocationCoordinate2D?
		
		guard shelter.attributes?.xCoordinate != nil && shelter.attributes?.yCoordinate != nil else {
			return nil
		}
	}
}
