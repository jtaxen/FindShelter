//
//  ResponseHandlerProtocol.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-17.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import CoreLocation

protocol ResponseHandlerProtocol {
	
	func coordinates(for shelter: ShelterObject) -> CLLocationCoordinate2D?
	
	func coordinates(for shelters: [ShelterObject]) -> [CLLocationCoordinate2D]?
}
