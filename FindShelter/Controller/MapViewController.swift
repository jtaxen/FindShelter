//
//  MapViewController.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	
	@IBOutlet weak var map: MKMapView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		map.delegate = self
		
        map.userTrackingMode = .follow
		
		
	}
}
