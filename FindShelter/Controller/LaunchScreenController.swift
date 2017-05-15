//
//  LaunchScreenController.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-15.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {
	
	
	
	override func viewDidLoad() {
		view.backgroundColor = ColorScheme.Background
		
		let storyboard = UIStoryboard.init(name: "LaunchScreen", bundle: nil)
		let controller = storyboard.instantiateInitialViewController() as! ChooseLanguageController
		present(controller, animated: true, completion: nil)
	}
	

	
}
