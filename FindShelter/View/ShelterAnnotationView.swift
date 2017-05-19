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
	
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /* override func draw(_ rect: CGRect) {
        
    }*/
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		image = #imageLiteral(resourceName: "Civil_defence")
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
