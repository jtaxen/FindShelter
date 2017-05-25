//
//  ShelterPointAnnotation.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-19.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import MapKit
import FBAnnotationClusteringSwift

class ShelterPointAnnotation: FBAnnotation {
	
	var shelter: ShelterObject?
	
	init(shelter: ShelterObject) {
		self.shelter = shelter
		super.init()
	}
	
	override init() {
		super.init()
	}
	
	public func set(shelter: ShelterObject) {
		self.shelter = shelter
	}	
}
