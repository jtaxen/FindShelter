//
//  ResultsMapper.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import ObjectMapper

class ArcGISResults: Mappable {
	
	var results: [ShelterObject]?
	
	required init?(map: Map) {}
	
	func mapping(map: Map) {
		results <- map["results"]
	}
}

class ShelterObject: Mappable {
	
	var layerId          : String?
	var layerName        : String?
	var displayFieldName : String?
	var foundFieldName   : String?
	var value            : String?
	var attributes       : Attributes?
	var geometryType     : String?
	var geometry         : Geometry?
	
	required init?(map: Map) {}
	
	func mapping(map: Map) {
		layerId          <- map["layerId"]
		layerName        <- map["layerName"]
		displayFieldName <- map["displayFieldName"]
		foundFieldName   <- map["foundFieldName"]
		value            <- map["value"]
		attributes       <- map["attributes"]
		geometryType     <- map["geometryType"]
		geometry         <- map["geometry"]
	}
}

// MARK: - Attributes
class Attributes: Mappable {
	
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
	
	// New keywords
	var inspireId             : String?
	var beginLifespan         : String?
	var endLifespan           : String?
	var typeOfOccupants       : String?
	var resourceFilter        : String?
	var serviceLevel          : String?
	var serviceType           : String?
	var pointOfContact        : String?
	var relatedPartner        : String?
	var additional            : String?
	var name                  : String?
	var serviceLBAddress      : String?
	var serviceLBCity         : String?
	var serviceLBMunicipality : String?
	var numberOfOccupants     : String?
	
	required init?(map: Map) {}
	
	func mapping(map: Map) {
		shape             <- map["Shape"]
		address           <- map["Gatuadress"]
		xCoordinate       <- map["XKoordinat"]
		yCoordinate       <- map["YKoordinat"]
		municipality      <- map["Kommunnamn"]
		town              <- map["Ortsnamn"]
		filterType        <- map["Filtertyp"]
		numberOfOccupants <- map["AntalPlatser"]
		estateDesignation <- map["Fastighetsbeteckning"]
		shelterNumber     <- map["Skyddsrumsnr"]
		airCleanerId      <- map["LuftrenareID"]
		coverId           <- map["coverID"]
		objectId          <- map["OBJECTID"]
		
		// Apparently they've changed these keys while I was working on the app
		// No wonder everything stopped working...
		// These are the new keys
		inspireId             <- map["InspireID"]
		beginLifespan         <- map["beginLifes"]
		endLifespan           <- map["endLifeSpa"]
		typeOfOccupants       <- map["typeOfOccu"]
		resourceFilter        <- map["resourceFi"]
		serviceLevel          <- map["serviceLev"]
		serviceType           <- map["serviceTyp"]
		pointOfContact        <- map["pointOfCon"]
		relatedPartner        <- map["relatedPar"]
		additional            <- map["additional"]
		name                  <- map["name"]
		serviceLBAddress      <- map["serviceLBA"]
		serviceLBCity         <- map["serviceLBC"]
		serviceLBMunicipality <- map["serviceLBM"]
		numberOfOccupants     <- map["numberOfOc"]
		
	}
}

// Geometry
class Geometry: Mappable {
	
	var xGeometry        : Int?
	var yGeometry        : Int?
	var spatialReference : SpatialReference?
	
	required init?(map: Map) {}
	
	func mapping(map: Map) {
		xGeometry        <- map["x"]
		yGeometry        <- map["y"]
		spatialReference <- map["spatialReference"]
	}
}

// MARK: - Spatial reference
class SpatialReference: Mappable {
	
	var wkid       : String?
	var latestWkid : String?
	
	required init?(map: Map) {}
	
	func mapping(map: Map) {
		wkid       <- map["wkid"]
		latestWkid <- map["latestWkid"]
	}
}
