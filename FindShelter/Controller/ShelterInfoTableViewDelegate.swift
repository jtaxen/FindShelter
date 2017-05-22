//
//  ShelterInfoTableViewDelegate.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-19.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension ShelterInfoTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 7
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		switch indexPath.row {
		case 0: cell.textLabel?.text = shelter.layerName ?? "No name"
		case 1: cell.textLabel?.text = shelter.attributes?.address ?? "No address"
		case 2: cell.textLabel?.text = shelter.attributes?.typeOfOccupants ?? "No occupants"
		case 3: cell.textLabel?.text = shelter.attributes?.serviceLBCity ?? "No city"
			cell.detailTextLabel?.text = "Stad"
		case 4: cell.textLabel?.text = shelter.attributes?.municipality ?? "No municipality"
			cell.detailTextLabel?.text = "Kommun"
		case 5: cell.textLabel?.text = shelter.attributes?.numberOfOccupants ?? "none"
			cell.detailTextLabel?.text = "Kapacitet"
		case 6:
			let squaredDistance = locationManager.location!.coordinate.squaredDistance(to: thisPosition)
			cell.textLabel?.text = "\(Int(sqrt(squaredDistance))) m"
			cell.detailTextLabel?.text = "Avstånd"
			
		default: cell.textLabel?.text = shelter.attributes?.pointOfContact
		}
		
		return cell
	}
	
}

extension ShelterInfoTableViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let coordinate = locations.last?.coordinate
		let cell = tableView.cellForRow(at: IndexPath(row: 6, section: 0))
		let squaredDistance = coordinate!.squaredDistance(to: thisPosition)
		cell?.textLabel?.text = "\(Int(sqrt(squaredDistance)))"
		
	}
}
