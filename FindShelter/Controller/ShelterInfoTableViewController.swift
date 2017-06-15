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
		tableView.isScrollEnabled = true
		tableView.tableFooterView = UIView()
		tableView.tableHeaderView = setUpHeader()
		
		setUpNavigationBar()
	}
	
	internal func setUpHeader() -> UIView {
		
		let rect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
		let label = UILabel(frame: rect)
		label.textAlignment = NSTextAlignment.center
		label.textColor = ColorScheme.Title
		label.font = UIFont(name: "Futura", size: 17)
		
		if let title = shelterObject?.attributes?.additional {
			label.text = title
			return label
		}
		
		CoreDataStack.shared?.persistingContext.performAndWait {
			if let title = self.shelterCoreData?.additional {
				label.text = title
			}
		}
		
		return (label.text != nil && label.text != "") ? label : UIView()
	}
}
