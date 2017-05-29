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
	
	convenience init?(_ item: ShelterObject, context: NSManagedObjectContext) {
		
		guard let entity = NSEntityDescription.entity(forEntityName: "Shelter", in: context) else {
			fatalError("Unable to find entity name")
		}
		
		self.init(entity: entity, insertInto: context)
		
		self.layerId           = item.layerId
		self.layerName         = item.layerName
		self.shape             = item.attributes?.shape
		self.address           = item.attributes?.serviceLBAddress
		self.xCoordinate       = Int32((item.geometry?.xGeometry)!)
		self.yCoordinate       = Int32((item.geometry?.yGeometry)!)
		self.municipality      = item.attributes?.municipality
		self.town              = item.attributes?.serviceLBCity
		self.filterType        = item.attributes?.resourceFilter
		self.capacity          = Int32((item.attributes?.numberOfOccupants)!)!
		self.estateDesignation = item.attributes?.estateDesignation
		self.shelterNumber     = item.attributes?.shelterNumber
		self.coverId           = item.attributes?.coverId
	}

}
