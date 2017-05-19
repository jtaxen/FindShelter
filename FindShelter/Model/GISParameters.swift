//
//  GISParameters.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

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
			ParameterKeys.Contains         : ParameterValues.Contains as AnyObject,
			ParameterKeys.Layers           : ParameterValues.Layers as AnyObject,
			ParameterKeys.ReturnGeometry   : ParameterValues.ReturnGeometry as AnyObject,
			ParameterKeys.F                : ParameterValues.F as AnyObject,
			ParameterKeys.SpatialReference : ParameterValues.SpatialReference as AnyObject
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
	public func makeParameters(search: String) -> [String: AnyObject] {
	
		var parameters = makeParameters()
		parameters[ParameterKeys.SearchText] = search as AnyObject
		return parameters
	}
}
