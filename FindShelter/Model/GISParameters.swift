//
//  GISParameters.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

class GISParameters: Parameters {

	static let shared = GISParameters()
	
	private init() {}
	
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
	
	public func makeParameters(search: String) -> [String: AnyObject] {
	
		var parameters = makeParameters()
		parameters[ParameterKeys.SearchText] = search as AnyObject
		return parameters
	}
}
