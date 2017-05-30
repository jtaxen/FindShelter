//
//  ShelterAnnotationView.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import MapKit

class ShelterAnnotationView: MKAnnotationView {
	
	public private(set) var isFavorite   : Bool!
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		image = #imageLiteral(resourceName: "Civil_defence")
		isFavorite = false
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public func setAsFavorite() {
		
		isFavorite = true
		image = #imageLiteral(resourceName: "favorite")
	}
	
	public func revokeAsFavorite() {
		
		isFavorite = false
		image = #imageLiteral(resourceName: "Civil_defence")
	}
	
	
	public func setAsTheClosest() {
		
		if isFavorite {
			image = #imageLiteral(resourceName: "favorie_closest")
		} else {
			image = #imageLiteral(resourceName: "closest")
		}
	}
	
	public func revokeAsTheClosest() {
		
		if isFavorite {
			image = #imageLiteral(resourceName: "favorite")
		} else {
			image = #imageLiteral(resourceName: "Civil_defence")
		}
	}
}
