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

/**
Annotation for shelters
*/
class ShelterPointAnnotation: FBAnnotation {
	
	var shelter: ShelterObject?
	var savedShelter: Shelter?
	public private(set) var isFavorite: Bool!
	
	init(shelter: ShelterObject) {
		self.shelter = shelter
		isFavorite = false
		super.init()
	}
	
	init(shelter: Shelter) {
		self.savedShelter = shelter
		isFavorite = true
		super.init()
	}
	
	override init() {
		super.init()
	}
	
	public func set(shelter: ShelterObject) {
		self.shelter = shelter
	}
	
	public func setAsFavorite() {
		isFavorite = true
		shelter?.isFavorite = true
	}
	
	public func removeAsFavorite() {
		isFavorite = false
		shelter?.isFavorite = false
	}
}
