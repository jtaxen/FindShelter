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
		if startUpdating {
			let closestPoint = distanceTool.findNearest(toElement: userLocation.coordinate)
			let endpoints = [userLocation.coordinate, closestPoint]
			let geodesicPolyline = MKGeodesicPolyline(coordinates: UnsafeMutablePointer(mutating: endpoints), count: 2)
			
			if mapView.overlays.count > 0 {
				mapView.remove(mapView.overlays.last!)
			}
			
			mapView.add(geodesicPolyline)
		}
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		if annotation.isEqual(map.userLocation) {
			return nil
		}
		
		let shelter = ShelterAnnotationView(annotation: annotation, reuseIdentifier: nil)
		return shelter
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		guard let polyline = overlay as? MKGeodesicPolyline else {
			return MKOverlayRenderer()
		}
		
		let renderer = MKPolylineRenderer(polyline: polyline)
		renderer.lineWidth = 2.0
		renderer.strokeColor = UIColor.blue
		renderer.alpha = 0.5
		return renderer
	}
	
}
