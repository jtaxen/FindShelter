//
//  LanguagePickerDelegate.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-15.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit

extension ChooseLanguageController: UIPickerViewDelegate, UIPickerViewDataSource {
	
	/// Number of components should always be one.
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return languages.count
	}
	
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		
		let attributes = [
			NSFontAttributeName: UIFont(name: "Futura", size: 17) as AnyObject,
			NSForegroundColorAttributeName: ColorScheme.Title as AnyObject
		]
		
		let string = NSAttributedString(string: languages[row], attributes: attributes)
		return string
	}
}
