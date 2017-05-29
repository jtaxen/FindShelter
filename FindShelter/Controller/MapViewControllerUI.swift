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

// MARK: - UI
/// Convenienve functions for setting up the subviews.
internal extension MapViewController {
	
	func setUpMap() {
		
		map.userTrackingMode = .follow
		map.region = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
	}
	
	func setUpInfoBar() {
		
		infoLabel.text = NSLocalizedString("Waiting for position...", comment: "Waiting for position")
		infoLabel.font = UIFont(name: "Futura", size: 17)
	}
	
	func setUpBackButton() {
		
		let backString = NSLocalizedString("Back", comment: "Back")
		let backButton = UIBarButtonItem(title: backString, style: .done, target: self, action: #selector(popView(_:)))
		backButton.tintColor = ColorScheme.Title
		let attributes = [NSFontAttributeName: UIFont(name: "Futura", size: 17) as Any,
		                  NSForegroundColorAttributeName: ColorScheme.Title as Any]
			
		backButton.setTitleTextAttributes(attributes, for: .normal)
		navigationItem.backBarButtonItem?.tintColor = ColorScheme.Title
		navigationItem.backBarButtonItem = backButton
		
		navigationController?.navigationBar.titleTextAttributes = attributes
	}
	
	func setUpFavoritesButton() {
		
		let favoriteButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(presentFavorites(_:)))
		favoriteButton.tintColor = ColorScheme.Title
		navigationItem.rightBarButtonItem = favoriteButton
	}
	
	@objc func popView(_ sender: UIBarButtonItem) {
		
		popView(sender)
	}
	
	@objc func presentFavorites(_ sender: UIBarButtonItem) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "favorites")
		navigationController?.pushViewController(controller, animated: true)
	}
}
