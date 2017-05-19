//
//  ShelterPointAnnotation.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-19.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import MapKit

class ShelterPointAnnotation: MKPointAnnotation {
	
	var shelter: ShelterObject
	
	init(shelter: ShelterObject) {
		self.shelter = shelter
		super.init()
	}
}
