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
		let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
		let shelter = shelters[indexPath.row]
		
		let swipeDeleteGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(deleteShelter(_:)))
		swipeDeleteGestureRecognizer.direction = .left
		cell.addGestureRecognizer(swipeDeleteGestureRecognizer)
		
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
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func deleteShelter(_ sender: UISwipeGestureRecognizer) {
		
		let alert = UIAlertController(title: NSLocalizedString("Delete shelter?", comment: "Ask if the user is sure that the shelter should be deleted") , message: NSLocalizedString("Are you sure that you want to delete this shelter?", comment: "Ask if the user is sure"), preferredStyle: .actionSheet)
		
		let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .destructive) { actionAlert in
			print(sender.location(in: self.tableView))
			
			if let indexPath = self.tableView.indexPathForRow(at: sender.location(in: self.tableView) ) {
				print("Samling vid pumpen")
				CoreDataStack.shared?.persistingContext.perform {
					
					CoreDataStack.shared?.persistingContext.delete(self.shelters[indexPath.row])
					self.shelters.remove(at: indexPath.row)
					DispatchQueue.main.async {
						self.tableView.deleteRows(at: [indexPath], with: .left)
						self.tableView.reloadData()
					}
					
					CoreDataStack.shared?.save()
				}
			}
		}
		let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { action in
			return
		}
		
		alert.addAction(confirmAction)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}
}
