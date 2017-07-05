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
		
        setUpNavigationBar()
		
		tableView.delegate   = self
		tableView.dataSource = self
		
		tableView.backgroundColor = ColorScheme.LightBackground
		
		let swipeDeleteGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(deleteShelter(_:)))
		swipeDeleteGestureRecognizer.direction = .left
		tableView.addGestureRecognizer(swipeDeleteGestureRecognizer)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		sortOutShelterDoublets()
	}
}


//MARK: - Delegate functions
/// This extension contains the relevant tableview delegate methods.
extension FavoritesTableViewController {
	
	/// There are as many rows as saved shelters.
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shelters.count
	}
	
	/**
	The cells are (for now) default table view cells. When the user swipes left
	on top of one cell, the cell disappears and the corresponding shelter is
	removed from the core data persisting context.
	*/
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
		let shelter = shelters[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "Futura", size: 17)
        cell.textLabel?.tintColor = ColorScheme.Title
		
		CoreDataStack.shared?.persistingContext.performAndWait {
			cell.textLabel?.text = shelter.address
		}
		cell.detailTextLabel?.text = ""
		
		return cell
	}
	
	/// Empty cells have zero height, so that they are not visible.
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row < shelters.count {
			return 60
		} else {
			return 0
		}
	}
	
	/**
	Selecting a row takes the user to a ShelterInfo tableview with the information
	about the selected shelter.
	*/
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
	
	/// All this is true
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	/**
	Method triggered when the user makes a left swipe on top of a cell. A popup
	appears and asks the user to confirm that he or she really wants to remove
	the item. It then removes the cell with an animation and removes the stored
	object from the Core Data context.
	*/
	@objc func deleteShelter(_ sender: UISwipeGestureRecognizer) {
		
		guard let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) else {
			print("Did not swipe on top of a cell")
			return
		}
		
		let alert = UIAlertController(title: NSLocalizedString("Delete shelter?", comment: "Ask if the user is sure that the shelter should be deleted") , message: NSLocalizedString("Are you sure that you want to delete this shelter?", comment: "Ask if the user is sure"), preferredStyle: .actionSheet)
		
		let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .destructive) { actionAlert in
			
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
		let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { action in
			return
		}
		
		alert.addAction(confirmAction)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}
    
    func setUpNavigationBar() {
        
        navigationItem.backBarButtonItem?.tintColor = ColorScheme.Title
        let attributes = [NSFontAttributeName: UIFont(name: "Futura", size: 17) as Any,
                          NSForegroundColorAttributeName: ColorScheme.Title as Any]
        
        navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        navigationController?.navigationBar.tintColor = ColorScheme.Title
    }
	
	/**
	When the view is loaded, this method goes through the shelter list and removes all doublets, 
	in case the user has saved the same shelter twice.
	*/
	func sortOutShelterDoublets() {
		
		var set = Set<String>()
		let result = shelters.filter { shelter in
			guard !set.contains(shelter.address!) else {
				CoreDataStack.shared?.persistingContext.performAndWait {
					CoreDataStack.shared?.persistingContext.delete(shelter)
				}
				return false
			}
			set.insert(shelter.address!)
			return true
		}
		shelters = result
		CoreDataStack.shared?.persistingContext.performAndWait {
			CoreDataStack.shared?.save()
		}
		tableView.reloadData()
	}
}
