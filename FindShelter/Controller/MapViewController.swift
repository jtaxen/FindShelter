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
		
		setUpMap()
		
		let client = ArcGISClient()
		
		client.makeAPIRequest(url: GISParameters.URL!, parameters: GISParameters.shared.makeParameters(search: "Skogsmyragatan")) { shelters in
			
			guard shelters != nil else {
				return
			}
			
			for shelter in shelters! {
				
				print(shelter.attributes!.address!)
			}
			
		}
		
//		print(MKMapPointForCoordinate(CLLocationCoordinate2DMake(0.0, 0.0)))
		let mpX = 134217728.0
		let mpY = 134217728.0
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = MKCoordinateForMapPoint(MKMapPointMake(mpX + 6611386, mpY + 619270 + 500000))
		print("First annotation: \(annotation.coordinate)")
		map.addAnnotation(annotation)
		
		let anothotation = MKPointAnnotation()
		annotation.coordinate = MKCoordinateForMapPoint(MKMapPointMake(134217728.0,134217728.0))
		print("Second annotation: \(anothotation.coordinate)")
		map.addAnnotation(anothotation)
		
		
	}
}
