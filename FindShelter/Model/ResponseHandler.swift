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

/// Class to take care of ArcGIS responeses.
public class ResponseHandler: ResponseHandlerProtocol {
	
	public static let shared = ResponseHandler()
	
	private var locationCoordinateList: [CLLocationCoordinate2D]!
	
	
	private init() {}
	
	/**
	Returns the coordinates for a ShelterObject in a format conforming
	to the CoreLocation format, in order to show the position in a MKMapView.
	- Parameter shelter: The ShelterObject from which the coordinates should
	be retrieved.
	- Returns: The coordinates as latitude and longitude.
	
	*/
	func coordinates(for shelter: ShelterObject) -> CLLocationCoordinate2D? {
		
		var locationCoordinate: CLLocationCoordinate2D?
		
		guard shelter.geometry?.xGeometry != nil && shelter.geometry?.yGeometry != nil else {
			debugPrint(Errors.new(code: 502))
			return nil
		}
		
		let north = shelter.geometry!.yGeometry
		let east = shelter.geometry!.xGeometry
		locationCoordinate = SpatialService.shared.convertUTMToLatLon(north: Double(north! + 11000), east: Double(east! + 300))
		return locationCoordinate
	}
	
	/**
	Returns a list of coordinates for each of the ShelterObjects in a list.
	- Parameter shelters: A list of ShelterObjects from which the coordinates
	should be retrieved.
	- Returns: A list of coordinates.
	*/
	func coordinates(for shelters: [ShelterObject]) -> [CLLocationCoordinate2D]? {
		var list: [CLLocationCoordinate2D] = []
		
		for shelter in shelters {
			if let newCoord = coordinates(for: shelter) {
				list.append(newCoord)
			}
		}
		return list
	}
}
