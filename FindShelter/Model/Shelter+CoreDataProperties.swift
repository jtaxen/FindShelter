//
//  Shelter+CoreDataProperties.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-15.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreData


extension Shelter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shelter> {
        return NSFetchRequest<Shelter>(entityName: "Shelter")
    }

    @NSManaged public var layerId           : String?
    @NSManaged public var layerName         : String?
    @NSManaged public var shape             : String?
    @NSManaged public var address           : String?
    @NSManaged public var xCoordinate       : Int32
    @NSManaged public var yCoordinate       : Int32
    @NSManaged public var municipality      : String?
    @NSManaged public var town              : String?
    @NSManaged public var filterType        : String?
    @NSManaged public var capacity          : Int32
    @NSManaged public var estateDesignation : String?
    @NSManaged public var shelterNumber     : String?
    @NSManaged public var coverId           : String?

}
