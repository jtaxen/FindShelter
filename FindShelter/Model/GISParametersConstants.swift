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
		
		static let Scheme = "https"
		static let Host   = "gis-services.metria.se"
		static let Path   = "/arcgis/rest/services/msb/InspireMSB_Skyddsrum/MapServer/find"
	}
	
	/// Returns an URL created from GISParameters.Constants
	static var URL: URL? {
		get {
			var urlC = URLComponents()
			urlC.scheme = Constants.Scheme
			urlC.host = Constants.Host
			urlC.path = Constants.Path
			do {
				return try urlC.asURL()
			} catch {
				debugPrint(error)
				return nil
			}
		}
	}
	
	/// Keys for making search requests.
	public struct ParameterKeys {
		
		static let SearchText       = "searchText"
		static let Contains         = "contains"
		static let Layers           = "layers"
		static let ReturnGeometry   = "returnGeometry"
		static let F                = "f"
		static let SpatialReference = "spatialReference"
	}
	
	/// Static values for the search requests.
	public struct ParameterValues {
		
		static let Contains         = true
		static let Layers           = 0
		static let ReturnGeometry   = true
		static let F                = "json"
		static let SpatialReference = "3006"
	}
}
