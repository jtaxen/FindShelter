//
//  MapViewControllerDelegate.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-16.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import MapKit
import FBAnnotationClusteringSwift

// MARK: - Map view delegate methods
extension MapViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		if following {
			mapView.centerCoordinate = userLocation.coordinate
		}
		
		if startUpdating {
			let closestPoint = distanceTool.findNearest(toElement: userLocation.coordinate)
			
			
			
			let endpoints = [userLocation.coordinate, closestPoint]
			let coordinates = UnsafeMutablePointer(mutating: endpoints)
			let geodesicPolyline = MKGeodesicPolyline(coordinates: coordinates, count: 2)
			
			if mapView.overlays.count > 0 {
				mapView.remove(mapView.overlays.last!)
			}
			mapView.add(geodesicPolyline)
			let dist = sqrt(userLocation.coordinate.squaredDistance(to: closestPoint))
			infoLabel.text = NSLocalizedString("The distance to the nearest shelter is \(Int(dist)) m", comment: "Distance to the nearest shelter is () m")
		}
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		
		if (view.annotation?.isEqual(mapView.userLocation))! {
			following = !following
			mapView.deselectAnnotation(view.annotation, animated: false)
		}
		
		if let annotation = view.annotation as? ShelterPointAnnotation {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "shelterTable") as! ShelterInfoTableViewController
			controller.shelterObject = annotation.shelter
			controller.thisPosition = annotation.coordinate
			navigationController?.pushViewController(controller, animated: true)
			mapView.deselectAnnotation(view.annotation, animated: false)
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		if annotation.isEqual(map.userLocation) { return nil }
		
		var reuseId: String!
		
		reuseId = "Shelter"
		var shelterView = map.dequeueReusableAnnotationView(withIdentifier: "Shelter")
		if shelterView == nil {
			shelterView = ShelterAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
		} else {
			shelterView?.annotation = annotation
		}
		return shelterView
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
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		
		
	}
	
	func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
		
		if mapView.region.span.latitudeDelta < 0.6 {
			
			
			client.makeAPIRequest(url: GISParameters.URL(.identify)! , parameters: GISParameters.shared.makeParameters(identify: mapView.centerCoordinate, inRadius: toleranceRadius(), mapExtent: mapView.region), completionHandler: completionHandlerForAPIRequest(_:))
		}
	}
}

// MARK: - Clustering manager delegate
extension MapViewController: FBClusteringManagerDelegate {
	
	func cellSizeFactorForCoordinator(_ coordinator: FBClusteringManager) -> CGFloat {
		return 1.0
	}
}

// TODO: - Remove this
extension MapViewController: UINavigationBarDelegate {
	
	func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
		return true
	}
}
