//
//  ShelterInfoTableViewControllerUI.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit

internal extension ShelterInfoTableViewController {
	
	func setUpNavigationBar() {
		
        navigationItem.backBarButtonItem?.tintColor = ColorScheme.Title
        let attributes = [NSFontAttributeName: UIFont(name: "Futura", size: 17) as Any,
                          NSForegroundColorAttributeName: ColorScheme.Title as Any]
        
        navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        navigationController?.navigationBar.tintColor = ColorScheme.Title
	}
}
