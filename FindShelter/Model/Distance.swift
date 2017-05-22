//
//  Distance.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-18.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation
import KDTree

class Distance {
	
	var tree: KDTree<CLLocationCoordinate2D>
	
	// ===
	let dir = URL(fileURLWithPath: "/Users/af/Udacity/HittaSkyddsrum/FindShelter/distancometer.data")
	
	
	
	init(_ dataPoints: [CLLocationCoordinate2D]) {
		tree = KDTree(values: dataPoints)
	}
	
	func findNearest(toElement element: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
		guard tree.elements.count > 0 else {
			return element
		}
		 
		let nearest = tree.nearest(toElement: element)!
		/**
		let output = "\(sqrt(element.squaredDistance(to: nearest))) \nq:"
		
		do {
			let fileHandle = try FileHandle(forWritingTo: dir)
			fileHandle.seekToEndOfFile()
			fileHandle.write(output.data(using: .utf8)!)
			fileHandle.closeFile()
		} catch {
			debugPrint(error)
		}
		*/
		return nearest
	}
	func findNearest(_ number: Int, toElement element: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
		return tree.nearestK(number, toElement: element)
	}
	
	func appendToTree(elements: [CLLocationCoordinate2D]) {
		for element in elements {
			tree = tree.inserting(element)
		}
	}
}
