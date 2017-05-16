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
		
		let client = ArcGISClient()
		
		client.makeAPIRequest(url: GISParameters.URL!, parameters: GISParameters.shared.makeParameters(search: "Skogsmyragatan")) { shelters in
			
			guard shelters != nil else {
				return
			}
			
			for shelter in shelters! {
				
				print(shelter.attributes!.address!)
			}
			
		}
	}
	
	
	
	
}
