//
//  GISParameters.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation

/**
The ArcGIS REST API has two methods which are being used in this application:
**find** and **identify**. This class generates arrays of parameters to 
make requests to both these method.
*/
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
	Creates a dictionary of key-value pair for a **find** request. The argument
	is a search string, and the other required parameters are constants fit
	for this application in particular.
	
	Parameter find: Single search term.
	
	Returns: A dictionary with the parameters needed to perform the request
	to the API.
	*/
	public func makeParameters(find searchText: String) -> [String: AnyObject] {
	
		var parameters = makeParameters()
		
		parameters[ParameterKeys.SearchText] = searchText as AnyObject
		parameters[ParameterKeys.Contains]   = ParameterValues.Contains as AnyObject
		parameters[ParameterKeys.Layers]     = ParameterValues.Layers as AnyObject
		
		return parameters
	}
	
	/**
	Creates a dictionary of key-value pairs for an **identify** request. The two 
	arguments are the geographical location in the vicinity of which the search
	should be performed, and the tolerance, e.g. how far away from this point
	items should be returned.
	
	Parameter identify: the point around which the search should be performed.
	Parameter inRadius: objects further away from the point than this are not
	returned from the server. The units are (currently) arbritrary.
	
	Returns: A dictionary with the parameters needed to perform the request to the
	*/
	public func makeParameters(identify point: CLLocationCoordinate2D, inRadius radius: Int = 1000) -> [String : AnyObject] {
		
		let utmPoint = SpatialService.shared.convertLatLonToUTM(point: point)
		let geometryString = "\(utmPoint.1),\(utmPoint.0)"
		let mapExtentString = "0,0,0,0"
		
		var parameters = makeParameters()
		
		parameters[ParameterKeys.Geometry]     = geometryString as AnyObject
		parameters[ParameterKeys.GeometryType] = ParameterValues.GeometryType as AnyObject
		parameters[ParameterKeys.Tolerance]    = radius as AnyObject
		parameters[ParameterKeys.MapExtent]    = mapExtentString as AnyObject
		parameters[ParameterKeys.ImageDisplay] = ParameterValues.ImageDisplay as AnyObject
		
		return parameters
	}
}
