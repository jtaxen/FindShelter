//
//  Shelter+CoreDataClass.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-15.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreData

@objc(Shelter)
public class Shelter: NSManagedObject {
	
	convenience init?(_ map: JSONMap, context: NSManagedObjectContext) {
		
		guard let entity = NSEntityDescription.entity(forEntityName: "Model", in: context) else {
			fatalError("Unable to find entity name")
		}
		
		self.init(entity: entity, insertInto: context)
		
		self.layerId           = map.layerId
		self.layerName         = map.layerName
		self.shape             = map.shape
		self.address           = map.address
		self.xCoordinate       = Int32(map.xCoordinate!)
		self.yCoordinate       = Int32(map.yCoordinate!)
		self.municipality      = map.municipality
		self.town              = map.town
		self.filterType        = map.filterType
		self.capacity          = Int32(map.capacity!)
		self.estateDesignation = map.estateDesignation
		self.shelterNumber     = map.shelterNumber
		self.coverId           = map.coverId
	}

}
