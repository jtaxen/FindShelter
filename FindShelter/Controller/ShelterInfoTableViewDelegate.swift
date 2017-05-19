//
//  ShelterInfoTableViewDelegate.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-19.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit

extension ShelterInfoTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		switch indexPath.row {
		case 0: cell.textLabel?.text = shelter.layerName ?? "No name"
		case 1: cell.textLabel?.text = shelter.value ?? "No value"
		default: cell.textLabel?.text = "Stay in school, kids"
		}
		
		return cell
	}
	
}
