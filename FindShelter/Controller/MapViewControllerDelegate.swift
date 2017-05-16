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
		
		let point = CGPoint(x: userLocation.coordinate.latitude, y: userLocation.coordinate.longitude)
		path.addLine(to: point)
		path.stroke()
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
	}
	
}