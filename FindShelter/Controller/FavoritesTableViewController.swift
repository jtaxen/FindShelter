//
//  FavoritesTableViewController.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-29.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {

	var shelters: [Shelter]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate   = self
		tableView.dataSource = self
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
		
		cell.textLabel?.text = shelter.address
		cell.detailTextLabel?.text = ""
		return cell
	}
}
