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

	var shelter: ShelterObject!
	var thisPosition: CLLocationCoordinate2D!
	var locationManager = CLLocationManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
