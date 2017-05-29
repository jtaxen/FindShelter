//
//  FavoritesTableViewCell.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-29.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewCell: UITableViewController {

	var shelters = [Shelter]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		CoreDataStack.shared?.persistingContext.performAndWait {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shelter")
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "xCoordinate", ascending: true)]
			let controller = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared!.persistingContext, sectionNameKeyPath: nil, cacheName: nil)
			do {
				try controller.performFetch()
				self.shelters = controller.fetchedObjects as! [Shelter]
			} catch {
				debugPrint(error)
			}
		}
		
		tableView.delegate   = self
		tableView.dataSource = self
	}
}

extension FavoritesTableViewCell {
	
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
		
		cell.textLabel?.text = shelter.attributes?.address
		cell.detailTextLabel?.text = ""
		return cell
	}
}
