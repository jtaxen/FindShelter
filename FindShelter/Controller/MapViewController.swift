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
	
	var coordinateList: [CLLocationCoordinate2D] = []
	var distanceTool: Distance!
	var startUpdating: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		map.delegate = self
		map.userTrackingMode = .follow
		
		setUpMap()
		distanceTool = Distance(coordinateList)
		
		let client = ArcGISClient()
		
		client.makeAPIRequest(url: GISParameters.URL!, parameters: GISParameters.shared.makeParameters(search: "Stockholm")) { shelters in
			
			guard shelters != nil else {
				return
			}
			
			guard let coordinates = ResponseHandler.shared.coordinates(for: shelters!) else {
				return
			}
			
			self.coordinateList = coordinates
			self.distanceTool.appendToTree(elements: coordinates)
			
			for cord in self.coordinateList {
				let annotation = MKPointAnnotation()
				annotation.coordinate = cord
				self.map.addAnnotation(annotation)
			}
			
			self.startUpdating = true
			
		}
	}
}
