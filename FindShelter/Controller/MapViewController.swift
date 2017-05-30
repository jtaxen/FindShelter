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
	let locationManager = LocationDelegate()
	
//	let clusterManager = FBClusteringManager()
//	let configuration = FBAnnotationClusterViewOptions(smallClusterImage: "smallCluster", mediumClusterImage: "mediumCluster", largeClusterImage: "largeCluster")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		map.delegate = self
		map.userTrackingMode = .follow
		
		
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		
		
		setUpMap()
		setUpInfoBar()
		setUpBackButton()
		setUpFavoritesButton()
		
		distanceTool = Distance(coordinateList)
		
//		clusterManager.delegate = self
		
		client.makeAPIRequest(url: GISParameters.URL(.identify)!, parameters: GISParameters.shared.makeParameters(identify: map.userLocation.coordinate, inRadius: toleranceRadius(), mapExtent: map.region), completionHandler: completionHandlerForAPIRequest(_:))
	}
	
	internal func completionHandlerForAPIRequest(_ shelters: [ShelterObject]?) {
		
		guard shelters != nil else {
			debugPrint(Errors.new(code: 502))
			return
		}
		
		for shelter in shelters! {
			if let coordinates = ResponseHandler.shared.coordinates(for: shelter) {
				self.shelterList[coordinates] = shelter
				self.coordinateList.append(coordinates)
			}
		}
		
		self.distanceTool.emptyTree()
		self.distanceTool.appendToTree(elements: self.coordinateList)
		
		var annotationArray: [FBAnnotation] = []
		for (coord, shl) in self.shelterList {
			let annotation = ShelterPointAnnotation(shelter: shl)
			annotation.coordinate = coord
			annotationArray.append(annotation)
		}
//		self.clusterManager.addAnnotations(annotationArray)
		map.addAnnotations(annotationArray)
		self.startUpdating = true
		
		DispatchQueue.main.async {
			self.mapView(self.map, didUpdate: self.map.userLocation)
		}
	}
}

extension MapViewController {
	
	internal func toleranceRadius() -> Int {
		
		let width = UIScreen.main.bounds.width
		let height = UIScreen.main.bounds.height
		
		let r2 = ((width.multiplied(by: width)) + (height.multiplied(by: height))) / 4
		// + 1 so that the radius is strictly larger than the screen radius after truncation
		return Int(sqrt(r2) + 1)
	}
}
