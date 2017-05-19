//
//  MapViewControllerDelegate.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
	
	func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
		// YES
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		mapView.centerCoordinate = userLocation.coordinate
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let shelter = ShelterAnnotationView(annotation: annotation, reuseIdentifier: nil)
		return shelter
	}
	
}
