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

extension MapViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		mapView.centerCoordinate = userLocation.coordinate
		
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
		if let annotation = view.annotation as? ShelterPointAnnotation {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "shelterTable") as! ShelterInfoTableViewController
			controller.shelter = annotation.shelter
			controller.thisPosition = annotation.coordinate
			present(controller, animated: true) {
				mapView.deselectAnnotation(annotation, animated: false)
			}
			
			
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		if annotation.isEqual(map.userLocation) {
			return nil
		}
		
		var reuseId: String
		
		if annotation.isMember(of: FBAnnotationCluster.self) {
			reuseId = "Cluster"
			var clusterView = map.dequeueReusableAnnotationView(withIdentifier: reuseId)
			if clusterView == nil {
				clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: FBAnnotationClusterViewOptions(smallClusterImage: "clusterSmall", mediumClusterImage: "clusterMedium", largeClusterImage: "clusterLarge"))
				
			} else {
				clusterView?.annotation = annotation
			}
			return clusterView
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
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		DispatchQueue.global(qos: .userInitiated).async {
			let mapBoundsWidth = Double(self.map.bounds.size.width)
			let mapRectWidth = self.map.visibleMapRect.size.width
			let scale = mapBoundsWidth / mapRectWidth
			
			let annotationArray = self.clusterHandle.clusteredAnnotationsWithinMapRect(self.map.visibleMapRect, withZoomScale: scale)
			DispatchQueue.main.async {
				self.clusterHandle.displayAnnotations(annotationArray, onMapView: self.map)
			}
		}
	}
}
