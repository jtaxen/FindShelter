//
//  GISParametersConstants.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
///
extension GISParameters {
	
	/// Constants for creating an URL to the server.
	public struct Constants {
		
		static let Scheme   = "https"
		static let Host     = "gis-services.metria.se"
		static let Path     = "/arcgis/rest/services/msb/InspireMSB_Skyddsrum/MapServer"
		static let Find     = "/find"
		static let Identify = "/identify"
	}
	
	/// Returns an URL created from GISParameters.Constants
	static var URL = { (_ method: Method) -> URL? in
		var urlC = URLComponents()
		urlC.scheme = Constants.Scheme
		urlC.host = Constants.Host
		urlC.path = Constants.Path
		
		switch method {
		case .find     : urlC.path += Constants.Find
		case .identify : urlC.path += Constants.Identify
		}
		
		do {
			return try urlC.asURL()
		} catch {
			debugPrint(error)
			return nil
		}
	}
	
	public enum Method {
		case find
		case identify
	}
	
	public struct ParameterKeys {
		
		static let F                = "f"
		static let SpatialReference = "sr"
		static let ReturnGeometry   = "returnGeometry"
		
		/// Keys for making find requests.
		static let SearchText       = "searchText"
		static let Contains         = "contains"
		static let Layers           = "layers"
		
		/// Keys for making identify requests.
		static let Geometry         = "geometry"
		static let GeometryType     = "geometryType"
		static let Tolerance        = "tolerance"
		static let MapExtent        = "mapExtent"
		static let ImageDisplay     = "imageDisplay"
	}
	
	
	public struct ParameterValues {
		
		static let F                = "json"
		static let SpatialReference = "3006"
		static let ReturnGeometry   = true
		
		/// Static values for the find requests.
		static let Contains         = true
		static let Layers           = "0,1"
		
		/// Static values for the identify requests.
		static let GeometryType     = "point"
		static let ImageDisplay     = "600,550,96"
	}
}
