//
//  FavoritesTableViewController.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-29.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class FavoritesTableViewController: UITableViewController {
	
	var shelters: [Shelter]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate   = self
		tableView.dataSource = self
		
		tableView.backgroundColor = ColorScheme.LightBackground
	}
}

extension FavoritesTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shelters.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("Shelters: \(shelters.count)")
		let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
		let shelter = shelters[indexPath.row]
		
		CoreDataStack.shared?.persistingContext.performAndWait {
			cell.textLabel?.text = shelter.address
		}
		cell.detailTextLabel?.text = ""
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row < 9 {
			return 60
		} else {
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "shelterTable") as! ShelterInfoTableViewController
		let thisShelter = shelters[indexPath.row]
		controller.shelterCoreData = thisShelter
		CoreDataStack.shared?.persistingContext.performAndWait{
			controller.thisPosition = SpatialService.shared.convertUTMToLatLon(north: Double(thisShelter.yCoordinate), east: Double(thisShelter.xCoordinate))
		}
		navigationController?.pushViewController(controller, animated: true)
		tableView.deselectRow(at: indexPath, animated: false)
	}
}
