//
//  JSONMap.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-15.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import ObjectMapper

class JSONMap: Mappable {
	
	var layerId           : String?
	var layerName         : String?
	var displayFieldName  : String?
	var foundFieldName    : String?
	var value             : String?
	var attributes        : [String: AnyObject]?
	var shape             : String?
	var address           : String?
	var xCoordinate       : Int?
	var yCoordinate       : Int?
	var municipality      : String?
	var town              : String?
	var filterType        : String?
	var capacity          : Int?
	var estateDesignation : String?
	var shelterNumber     : String?
	var airCleanerId      : String?
	var coverId           : String?
	var objectId          : Int?
	var geometryType      : String?
	var geometry          : [String: AnyObject]?
	var geometryX         : Int?
	var geometryY         : Int?
	var spatialReference  : [String: AnyObject]?
	var wkid              : String?
	var latestWkid        : String?
	
	required init?(map: Map) {
	}
	
	func mapping(map: Map) {
		layerId           <- map["layerId"]
		layerName         <- map["layerName"]
		displayFieldName  <- map["displayFieldName"]
		foundFieldName    <- map["foundFieldName"]
		value             <- map["value"]
		attributes        <- map["attributes"]
		shape             <- map["shape"]
		address           <- map["Gatuadress"]
		xCoordinate       <- map["XKoordinat"]
		yCoordinate       <- map["YKoordinat"]
		municipality      <- map["Kommunnamn"]
		town              <- map["Ortsnamn"]
		filterType        <- map["Filtertyp"]
		capacity          <- map["AntalPlatser"]
		estateDesignation <- map["Fastighetsbeteckning"]
		shelterNumber     <- map["Skyddsrumsnr"]
		airCleanerId      <- map["LuftrenareID"]
		coverId           <- map["coverID"]
		objectId          <- map["OBJECTID"]
		geometryType      <- map["geometryType"]
		geometry          <- map["geometry"]
		geometryX         <- map["x"]
		geometryY         <- map["y"]
		spatialReference  <- map ["spatialReference"]
		wkid              <- map["wkid"]
		latestWkid        <- map["latestWkid"]
	}
	
}
