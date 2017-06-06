//
//  ShelterInfoTableViewController.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-19.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import CoreLocation

class ShelterInfoTableViewController: UITableViewController {
	
	var shelterObject: ShelterObject?
	var shelterCoreData: Shelter?
	var thisPosition: CLLocationCoordinate2D!
	var locationManager = LocationDelegate()
	internal var words = Words()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.isScrollEnabled = false
		tableView.tableFooterView = UIView()
		
		setUpNavigationBar()
	}
}
