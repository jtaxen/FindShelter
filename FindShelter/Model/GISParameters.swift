//
//  GISParameters.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation

public class GISParameters: Parameters {

	static let shared = GISParameters()
	
	private init() {}
	
	/**
	Creates a parameter dictionary to be used with ArcGISClient.makeAPIRequest()
	for making search requests to [msb/InspireMSB_Skyddsrum (MapServer)](https://gis-services.metria.se/arcgis/rest/services/msb/InspireMSB_Skyddsrum/MapServer)
	using the ArcGIS searchText method without any search string.
	- Returns: A dictionary with query key strings and their respective value.
	*/
	public func makeParameters() -> [String: AnyObject] {
		let parameters = [
			ParameterKeys.F                : ParameterValues.F as AnyObject,
			ParameterKeys.SpatialReference : ParameterValues.SpatialReference as AnyObject,
			ParameterKeys.ReturnGeometry   : ParameterValues.ReturnGeometry as AnyObject
		]
		return parameters
	}
	
	/**
	Creates a parameter dictionary using makeParameters() and adds a search
	string.
	- Parameter search: string containings a search string such as a street,
	district or city name.
	- Returns: A dictionary with query key strings and their respective value.
	*/
	public func makeParameters(find searchText: String) -> [String: AnyObject] {
	
		var parameters = makeParameters()
		
		parameters[ParameterKeys.SearchText] = searchText as AnyObject
		parameters[ParameterKeys.Contains]   = ParameterValues.Contains as AnyObject
		parameters[ParameterKeys.Layers]     = ParameterValues.Layers as AnyObject
		
		return parameters
	}
	
	public func makeParameters(identify point: CLLocationCoordinate2D, inRadius radius: Int = 100) -> [String : AnyObject] {
		
		let utmPoint = SpatialService.shared.convertLatLonToUTM(point: point)
		let geometryString = "\(utmPoint.0),\(utmPoint.1)"
		let mapExtentString = "\(utmPoint.0 - 1),\(utmPoint.1 - 1),\(utmPoint.0 + 1),\(utmPoint.1 + 1)"
		
		var parameters = makeParameters()
		
		parameters[ParameterKeys.Geometry]     = geometryString as AnyObject
		parameters[ParameterKeys.GeometryType] = ParameterValues.GeometryType as AnyObject
		parameters[ParameterKeys.Tolerance]    = radius as AnyObject
		parameters[ParameterKeys.MapExtent]    = mapExtentString as AnyObject
		parameters[ParameterKeys.ImageDisplay] = ParameterValues.ImageDisplay as AnyObject
		
		return parameters
	}
}
