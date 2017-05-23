//
//  ShelterCellTableViewCell.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class ShelterCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	private func setUpUI() {
		
		textLabel?.font = UIFont(name: "Futura", size: 17)
		textLabel?.textColor = UIColor.black
		
		detailTextLabel?.font = UIFont(name: "Futura", size: 10)
		detailTextLabel?.textColor = UIColor.black
		
		backgroundColor = ColorScheme.LightBackground
	}
}
