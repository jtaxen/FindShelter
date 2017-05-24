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
import FBAnnotationClusteringSwift

class MapViewController: UIViewController {
	
	@IBOutlet weak var map: MKMapView!
	@IBOutlet weak var infoLabel: UILabel!
	
	var coordinateList: [CLLocationCoordinate2D] = []
	var shelterList: [CLLocationCoordinate2D: ShelterObject] = [:]
	var distanceTool: Distance!
	var startUpdating: Bool = false
	var following: Bool = false
	
	let client = ArcGISClient()
	
	let clusterManager = FBClusteringManager()
	let configuration = FBAnnotationClusterViewOptions(smallClusterImage: "smallCluster", mediumClusterImage: "mediumCluster", largeClusterImage: "largeCluster")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		map.delegate = self
		map.userTrackingMode = .follow
		
		setUpMap()
		setUpInfoBar()
		setUpBackButton()
		print(navigationController == nil)
		
		distanceTool = Distance(coordinateList)
		
		clusterManager.delegate = self
		
		client.makeAPIRequest(url: GISParameters.URL(.find)!, parameters: GISParameters.shared.makeParameters(find: "Malmö")) { shelters in
			
			guard shelters != nil else {
				return
			}
			
			for shelter in shelters! {
				if let coordinates = ResponseHandler.shared.coordinates(for: shelter) {
					self.shelterList[coordinates] = shelter
					self.coordinateList.append(coordinates)
				}
			}
			self.distanceTool.appendToTree(elements: self.coordinateList)
			
			var annotationArray: [FBAnnotation] = []
			for (coord, shl) in self.shelterList {
				let annotation = ShelterPointAnnotation(shelter: shl)
				annotation.coordinate = coord
				annotationArray.append(annotation)
			}
			self.clusterManager.addAnnotations(annotationArray)
			self.startUpdating = true
			
			DispatchQueue.main.async {
				self.mapView(self.map, didUpdate: self.map.userLocation)
			}
			
		}
	}
}
