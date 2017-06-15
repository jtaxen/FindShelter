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
	
	/// Only one section needed.
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	/// There are seven attributes which are useful to the user, and one row for favorite button.
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 8
	}
	
	/// The information for downloaded and saved items is stored slightly different, so unfortunately
	/// different keywords are needed for each case.
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShelterCellTableViewCell
		
		if shelterObject != nil {
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = shelterObject!.attributes?.serviceLBAddress ?? words.noAddress
				cell.detailTextLabel?.text = words.sAddress
			case 1:
				cell.textLabel?.text = shelterObject!.attributes?.typeOfOccupants ?? words.noOccupants
				cell.detailTextLabel?.text = words.sOccupants
			case 2:
				cell.textLabel?.text = shelterObject!.attributes?.serviceLBCity ?? words.noCity
				cell.detailTextLabel?.text = words.sCity
			case 3:
				cell.textLabel?.text = shelterObject!.attributes?.serviceLBMunicipality ?? words.noMunicipality
				cell.detailTextLabel?.text = words.sMunicipality
			case 4:
				cell.textLabel?.text = shelterObject!.attributes?.numberOfOccupants != nil ? shelterObject!.attributes!.numberOfOccupants! + " " + words.sPersons : words.noCapacity
				cell.detailTextLabel?.text = words.sCapacity
			case 5:
				if let squaredDistance = locationManager.location?.coordinate.squaredDistance(to: thisPosition) {
					cell.textLabel?.text = "\(Int(sqrt(squaredDistance))) m"
				} else {
					cell.textLabel?.text = words.noDistance
				}
				cell.detailTextLabel?.text = words.sDistance
				
			case 6:
				cell.textLabel?.text = shelterObject!.attributes?.pointOfContact ?? words.noPointOfC
				cell.detailTextLabel?.text = words.sPointOfC
			case 7:
				cell.textLabel?.text = words.sSave
				cell.detailTextLabel?.text = ""
			default: break
			}
			
		} else if shelterCoreData != nil {
			CoreDataStack.shared?.persistingContext.performAndWait{
				switch indexPath.row {
				case 0:
					cell.textLabel?.text = self.shelterCoreData!.address ?? self.words.noAddress
					cell.detailTextLabel?.text = self.words.sAddress
				case 1:
					cell.textLabel?.text = self.shelterCoreData?.occupants ?? self.words.noCapacity
					cell.detailTextLabel?.text = self.words.sOccupants
				case 2:
					cell.textLabel?.text = self.shelterCoreData?.town ?? self.words.noCity
					cell.detailTextLabel?.text = self.words.sCity
				case 3:
					cell.textLabel?.text = self.shelterCoreData?.municipality ?? self.words.noMunicipality
					cell.detailTextLabel?.text = self.words.sMunicipality
				case 4:
					cell.textLabel?.text = "\(self.shelterCoreData?.capacity ?? 0)" + " " + self.words.sPersons
					cell.detailTextLabel?.text = self.words.sCapacity
				case 5:
					if let squaredDistance = self.locationManager.location?.coordinate.squaredDistance(to: self.thisPosition) {
						cell.textLabel?.text = "\(Int(sqrt(squaredDistance))) m"
					} else {
						cell.textLabel?.text = self.words.noDistance
					}
					cell.detailTextLabel?.text = self.words.sDistance
					
				case 6:
					cell.textLabel?.text = self.shelterCoreData?.pointOfContact ?? self.words.noPointOfC
					cell.detailTextLabel?.text = self.words.sPointOfC
				case 7:
					cell.textLabel?.text = self.words.sCenter
					cell.detailTextLabel?.text = ""
				default: break
				}
			}
		}
		return cell
	}
	
	/// If the user selects row eight, it either saves the shelter to favorites or, if the shelter is already saved, returns to the map view with the shelter centered.
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		switch indexPath.row {
		case 7:
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

// MARK: - Location manager delegate
extension ShelterInfoTableViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let coordinate = locations.last?.coordinate
		let cell = tableView.cellForRow(at: IndexPath(row: 6, section: 0))
		let squaredDistance = coordinate!.squaredDistance(to: thisPosition)
		cell?.textLabel?.text = "\(Int(sqrt(squaredDistance)))"
		
	}
}

// MARK: - Table strings
extension ShelterInfoTableViewController {
	
	internal struct Words {
		let sName          = NSLocalizedString("Name",                               comment : "name")
		let sAddress       = NSLocalizedString("Address",                            comment : "address")
		let sOccupants     = NSLocalizedString("Intended_for",                       comment : "intended for")
		let sCity          = NSLocalizedString("City",                               comment : "city")
		let sMunicipality  = NSLocalizedString("Municipality",                       comment : "municipality")
		let sPersons       = NSLocalizedString("people",                             comment : "unit for capacity")
		let sCapacity      = NSLocalizedString("Capacity",                           comment : "capacity")
		let sDistance      = NSLocalizedString("Distance",                           comment : "distance from the user")
		let sPointOfC      = NSLocalizedString("Point_of_contact",                   comment : "Point of contact")
		let sSave          = NSLocalizedString("Save",                               comment : "save button")
		let sCenter        = NSLocalizedString("Show_shelter_on_map",                comment : "center on map")
		
		let noName         = NSLocalizedString("Name_is_missing",                    comment : "name is missing")
		let noAddress      = NSLocalizedString("Address_is_missing",                 comment : "address is missing")
		let noOccupants    = NSLocalizedString("No_information",                     comment : "no information")
		let noCity         = NSLocalizedString("City_is_missing",                    comment : "city is missing")
		let noMunicipality = NSLocalizedString("Municipality_is_missing",            comment : "no municip")
		let noCapacity     = NSLocalizedString("Capacity_unknown",                   comment : "capacity unknown")
		let noDistance     = NSLocalizedString("Cannot_find_your_current_position",  comment : "user position is lacking")
		let noPointOfC     = NSLocalizedString("No_information",                     comment : "pointofc is missing")
	}
}
