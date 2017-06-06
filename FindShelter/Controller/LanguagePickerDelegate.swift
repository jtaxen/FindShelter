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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = ColorScheme.Title
        label.font = UIFont(name: "Futura", size: 17)
        label.text = languages[row]
        
        return label
    }
}
