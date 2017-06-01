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
	
	/**
	When the user location changes, several things happens:
	#1, If the map is set to track the position, the map centers around the user location.
	#2, If the distance between the user location and the point where the last update 
	    was made is greater than half the distance of the last search's tolerance radius,
        a new update is made, to load new shelters before the user sees the empty area
	    on the screen (the units that are compared are meters to points, so it is rather
	    arbitrarily implemented as of now).
	#3, If the first request has been made (that is, if startUpdating == true), it is 
	    decided which shelter is the closest, and a line between it and the user is 
	    overlayed.
	*/
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		if following {
			mapView.centerCoordinate = userLocation.coordinate
		}
		
		if locationOfLatestUpdate != nil {
			
			if sqrt(userLocation.coordinate.squaredDistance(to: locationOfLatestUpdate!)) > Double(toleranceRadius()) / 2 && toleranceRadius() > 0 {
				client.makeAPIRequest(url: GISParameters.URL(.identify)! , parameters: GISParameters.shared.makeParameters(identify: mapView.centerCoordinate, inRadius: toleranceRadius(), mapExtent: mapView.region), completionHandler: completionHandlerForAPIRequest(_:))
			}
		}
		
		if startUpdating {
			if userAnnotationIsVisible() {
				let closestPoint = distanceTool.findNearest(toElement: userLocation.coordinate)
				
				let dist = sqrt(userLocation.coordinate.squaredDistance(to: closestPoint))
				if dist < 5000 {
					infoLabel.text = NSLocalizedString("The distance to the nearest shelter is \(Int(dist)) m", comment: "Distance to the nearest shelter is () m")
				}
				
				guard closestPoint != closestShelter else {
					return
				}
				
				closestShelter = closestPoint
				let circle = MKCircle(center: closestPoint, radius: 6)
				
//				let endpoints = [userLocation.coordinate, closestPoint]
//				let coordinates = UnsafeMutablePointer(mutating: endpoints)
//				let geodesicPolyline = MKGeodesicPolyline(coordinates: coordinates, count: 2)
				
				if mapView.overlays.count > 0 {
					mapView.removeOverlays(map.overlays)
				}
				mapView.add(circle)
//				mapView.add(geodesicPolyline)
				

			} else {
				
				if mapView.overlays.count > 0 {
					mapView.remove(mapView.overlays.last!)
				}
				infoLabel.text = ""
			}
		}
	}
	
	/**
	Selecting an annotation takes the user to a table view with detailed
	information about the shelter.
	*/
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
		
		// The user location annotation should be the default one.
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
	
	/// An overlay is added, namely a blue line connecting the user location annotation with the closest shelter annotation.
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		
		
		if overlay is MKGeodesicPolyline {
		
			let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
			renderer.lineWidth = 2.0
			renderer.strokeColor = UIColor.blue
			renderer.alpha = 0.5
			return renderer
		}
		
		if overlay is MKCircle {
			
			let renderer = MKCircleRenderer(circle: overlay as! MKCircle)
			renderer.lineWidth = 0.0
			renderer.strokeColor = UIColor.blue
			renderer.alpha = 1.0
			return renderer
		}
		
		return MKOverlayRenderer()
	}
	
	/// If the user annotation is not visible on the screen, the shelters are updated every time this method is called.
	func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
		
		if !userAnnotationIsVisible() {
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
