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



internal extension ShelterInfoTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 9
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShelterCellTableViewCell
		
		if shelterObject != nil {
			switch indexPath.row {
			case 0: cell.textLabel?.text = shelterObject!.layerName ?? "No name"
			case 1: cell.textLabel?.text = shelterObject!.attributes?.serviceLBAddress ?? "No address"
			case 2: cell.textLabel?.text = shelterObject!.attributes?.typeOfOccupants ?? "No occupants"
			case 3: cell.textLabel?.text = shelterObject!.attributes?.serviceLBCity ?? "No city"
			cell.detailTextLabel?.text = "Stad"
			case 4: cell.textLabel?.text = shelterObject!.attributes?.serviceLBMunicipality ?? "No municipality"
			cell.detailTextLabel?.text = "Kommun"
			case 5: cell.textLabel?.text = shelterObject!.attributes?.numberOfOccupants ?? "none"
			cell.detailTextLabel?.text = "Kapacitet"
			case 6:
				let squaredDistance = locationManager.location!.coordinate.squaredDistance(to: thisPosition)
				cell.textLabel?.text = "\(Int(sqrt(squaredDistance))) m"
				cell.detailTextLabel?.text = "Avstånd"
				
			case 7: cell.textLabel?.text = shelterObject!.attributes?.pointOfContact
			cell.detailTextLabel?.text = "Point of contact"
			case 8: cell.textLabel?.text = "Save"
			cell.detailTextLabel?.text = ""
			default: break
			}
		} else if shelterCoreData != nil {
			CoreDataStack.shared?.persistingContext.performAndWait{
				switch indexPath.row {
				case 0: cell.textLabel?.text = self.shelterCoreData!.layerName ?? "No name"
				case 1: cell.textLabel?.text = self.shelterCoreData!.address ?? "No address"
				case 2: cell.textLabel?.text = "No occupants"
				case 3: cell.textLabel?.text = self.shelterCoreData?.town ?? "No city"
				case 4: cell.textLabel?.text = self.shelterCoreData?.municipality ?? "No municipality"
				case 5: cell.textLabel?.text = "\(self.shelterCoreData?.capacity ?? 0)"
				case 6:
					let squaredDistance = self.locationManager.location?.coordinate.squaredDistance(to: self.thisPosition)
					cell.textLabel?.text = "\(Int(sqrt(squaredDistance!))) m"
					cell.detailTextLabel?.text = "Distance"
					
				case 7: cell.textLabel?.text = "Point of contact"
				case 8: cell.textLabel?.text = "Show on map"
				cell.detailTextLabel?.text = ""
				default: break
				}
			}
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		switch indexPath.row {
		case 8:
			if shelterObject != nil {
				CoreDataStack.shared?.persistingContext.perform {
					_ = Shelter(self.shelterObject!, context: (CoreDataStack.shared?.persistingContext)!)
					CoreDataStack.shared?.save()
					DispatchQueue.main.async {
						tableView.deselectRow(at: indexPath, animated: false)
					}
				}
			} else if shelterCoreData != nil {
				
				let rootController = navigationController?.viewControllers[0] as! MapViewController
				rootController.map.centerCoordinate = thisPosition
				rootController.map.delegate?.mapViewDidFinishLoadingMap!(rootController.map)
				navigationController?.popToRootViewController(animated: true)
			}
			
		default: tableView.deselectRow(at: indexPath, animated: false)
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row < 9 {
			return 60
		} else {
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row < 9 {
			return 60
		} else {
			return 0
		}
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
