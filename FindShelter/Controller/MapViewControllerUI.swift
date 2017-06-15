//
//  MapViewControllerUI.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import UIKit
import CoreData

// MARK: - UI
/// Convenienve functions for setting up the subviews.
internal extension MapViewController {
	
	
	func setUpMap() {
		
		map.region = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
	}
	
	func setUpInfoBar() {
		
		infoLabel.text = NSLocalizedString("waiting_for_position", comment: "Waiting for position")
		infoLabel.font = UIFont(name: "Futura", size: 17)
		infoLabel.numberOfLines = 1
		infoLabel.adjustsFontSizeToFitWidth = true
	}
	
	func setUpBackButton() {
		
		let backString = NSLocalizedString("back", comment: "Back")
		let backButton = UIBarButtonItem(title: backString, style: .done, target: self, action: #selector(popView(_:)))
		backButton.tintColor = ColorScheme.Title
		let attributes = [NSFontAttributeName: UIFont(name: "Futura", size: 17) as Any,
		                  NSForegroundColorAttributeName: ColorScheme.Title as Any]
			
		backButton.setTitleTextAttributes(attributes, for: .normal)
		navigationItem.backBarButtonItem?.tintColor = ColorScheme.Title
		navigationItem.backBarButtonItem = backButton
		
		navigationController?.navigationBar.titleTextAttributes = attributes
		navigationController?.navigationBar.tintColor = ColorScheme.Title
	}
	
	func setUpFavoritesButton() {
		
		let favoriteButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(presentFavorites(_:)))
		favoriteButton.tintColor = ColorScheme.Title
		navigationItem.rightBarButtonItem = favoriteButton
	}
	
	func setUpCenterUserButton() {
		
		let centerButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(centerUser(_:)))
		centerButton.tintColor = ColorScheme.Title
		client.makeAPIRequest(url: GISParameters.URL(.identify)! , parameters: GISParameters.shared.makeParameters(identify: map.centerCoordinate, inRadius: toleranceRadius(), mapExtent: map.region), completionHandler: completionHandlerForAPIRequest(_:))
		navigationItem.leftBarButtonItem = centerButton
	}
	
	@objc func popView(_ sender: UIBarButtonItem) {
		
		popView(sender)
	}
	
	@objc func presentFavorites(_ sender: UIBarButtonItem) {
		
		CoreDataStack.shared?.persistingContext.performAndWait {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shelter")
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "xCoordinate", ascending: true)]
			let controller = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared!.persistingContext, sectionNameKeyPath: nil, cacheName: nil)
			do {
				try controller.performFetch()
				DispatchQueue.main.async {
					let storyboard = UIStoryboard(name: "Main", bundle: nil)
					let viewController = storyboard.instantiateViewController(withIdentifier: "favorites") as! FavoritesTableViewController
					viewController.shelters = controller.fetchedObjects as! [Shelter]
					self.navigationController?.pushViewController(viewController, animated: true)
				}
				
			} catch {
				debugPrint(error)
			}
		}
	}
	
	@objc func centerUser(_ sender: UIBarButtonItem) {
		
		map.setUserTrackingMode(.follow, animated: true)
		
		client.makeAPIRequest(url: GISParameters.URL(.identify)! , parameters: GISParameters.shared.makeParameters(identify: map.centerCoordinate, inRadius: toleranceRadius(), mapExtent: map.region), completionHandler: completionHandlerForAPIRequest(_:))
		
	}
}
