//
//  MapViewController.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
	
	@IBOutlet weak var map: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		map.delegate = self
		map.userTrackingMode = .follow
		
		setUpMap()
		
		let client = ArcGISClient()
		
		client.makeAPIRequest(url: GISParameters.URL!, parameters: GISParameters.shared.makeParameters(search: "Stockholm")) { shelters in
			
			guard shelters != nil else {
				return
			}
			
			let coords = ResponseHandler.shared.coordinates(for: shelters!)
			
			for cord in coords! {
				let annotation = MKPointAnnotation()
				annotation.coordinate = cord
				self.map.addAnnotation(annotation)
			}
		}
	}
}
