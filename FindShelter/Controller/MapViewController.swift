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
import CoreData

class MapViewController: UIViewController {
	
	@IBOutlet weak var map: MKMapView!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	
	var coordinateList         : [CLLocationCoordinate2D] = []
	var shelterList            : [CLLocationCoordinate2D : ShelterObject] = [:]
	var savedList              : [CLLocationCoordinate2D : Shelter] = [:]
	var distanceTool           : Distance!
	var startUpdating          : Bool = false
	var following              : Bool = false
	var firstUpdateDone        : Bool = false
	var locationOfLatestUpdate : CLLocationCoordinate2D?
	var closestShelter         : CLLocationCoordinate2D?
	
	let client = ArcGISClient()
	let locationManager = LocationDelegate()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let lang = UserDefaults.standard.string(forKey: "AppleLanguages") {
			UserDefaults.standard.removeObject(forKey: "AppleLanguages")
			UserDefaults.standard.set(lang, forKey: "AppleLanguages")
			UserDefaults.standard.synchronize()
		}
		
		map.delegate = self
		
		locationManager.requestWhenInUseAuthorization()
		map.setUserTrackingMode(.follow, animated: true)
		
		distanceTool = Distance(coordinateList)
		
		setUpMap()
		setUpInfoBar()
		setUpSpinner()
		setUpBackButton()
		setUpFavoritesButton()
		setUpCenterUserButton()
		fetchAndDisplaySavedShelters()
		
		spinner.startAnimating()
		client.makeAPIRequest(url: GISParameters.URL(.identify)!, parameters: GISParameters.shared.makeParameters(identify: map.userLocation.coordinate, inRadius: toleranceRadius(), mapExtent: map.region), completionHandler: completionHandlerForAPIRequest(_:))
		
	}
	
	/**
	*/
	internal func completionHandlerForAPIRequest(_ shelters: [ShelterObject]?) {
		
		
		locationOfLatestUpdate = map.userLocation.coordinate
		
		guard shelters != nil else {
			debugPrint(Errors.new(code: 502))
			let alert = self.networkAlert()
			present(alert, animated: true, completion: nil)
			return
		}
		
		// Remove earlier shelters for better prestanda
		shelterList.removeAll()
		coordinateList.removeAll()
		map.removeAnnotations(map.annotations)
		
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
		
		map.addAnnotations(annotationArray)
		self.startUpdating = true
		
		DispatchQueue.main.async {
			self.mapView(self.map, didUpdate: self.map.userLocation)
			self.spinner.stopAnimating()
		}
	}
	
	internal func networkAlert() -> UIAlertController {
		
		let tryAgain = UIAlertAction(title: NSLocalizedString("try_again", comment: "try again"), style: .default) { alert in
			self.client.makeAPIRequest(url: GISParameters.URL(.identify)!, parameters: GISParameters.shared.makeParameters(identify: self.map.userLocation.coordinate, inRadius: self.toleranceRadius(), mapExtent: self.map.region), completionHandler: self.completionHandlerForAPIRequest(_:))
		}
		
		let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel"), style: .cancel, handler: nil)
		
		let alert = UIAlertController(title: NSLocalizedString("Network_down", comment: "Server request failed"), message: NSLocalizedString("Network_down_message", comment: ""), preferredStyle: .alert)
		alert.addAction(tryAgain)
		alert.addAction(cancel)
		
		return alert
	}
	
	internal func fetchAndDisplaySavedShelters() {
		
		CoreDataStack.shared?.persistingContext.performAndWait {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shelter")
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "xCoordinate", ascending: true)]
			let controller = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared!.persistingContext, sectionNameKeyPath: nil, cacheName: nil)
			
			do {
				try controller.performFetch()
				guard let fetchedObjects = controller.fetchedObjects as? [Shelter] else {
					debugPrint(Errors.new(code: 600))
					return
				}
				
				for object in fetchedObjects{
					let coord = CLLocationCoordinate2D(latitude: object.latitude, longitude: object.longitude)
					self.savedList[coord] = object
					let annotation = ShelterPointAnnotation(shelter: object)
					annotation.coordinate = coord
					self.map.addAnnotation(annotation)
				}
				
			} catch {
				debugPrint(error)
			}
		}
	}
}

extension MapViewController {
	
	internal func toleranceRadius() -> Int {
		
		// If the user has zoomed out to far, no new annotations should appear
		if map.region.span.latitudeDelta > 0.6 {
			return -1
		}
		
		let width = UIScreen.main.bounds.width
		let height = UIScreen.main.bounds.height
		
		let r2 = ((width.multiplied(by: width)) + (height.multiplied(by: height))) / 4
		// + 1 so that the radius is strictly larger than the screen radius after truncation
		return Int(sqrt(r2) + 1)
	}
	
	internal func userAnnotationIsVisible() -> Bool {
		
		let userX = map.userLocation.coordinate.longitude
		let userY = map.userLocation.coordinate.latitude
		
		let south = map.region.center.latitude - map.region.span.latitudeDelta / 2
		let west  = map.region.center.longitude - map.region.span.longitudeDelta / 2
		let north = map.region.center.latitude + map.region.span.latitudeDelta / 2
		let east  = map.region.center.longitude + map.region.span.longitudeDelta / 2
		
		if userX < east && userX > west && userY < north && userY > south {
			return true
		}
		
		return false
	}
}
