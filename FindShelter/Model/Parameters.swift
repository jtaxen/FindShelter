//
//  Parameters.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

protocol Parameters {
	
	func makeParameters() -> [String: AnyObject]
	
	func makeParameters(search: String) -> [String: AnyObject]
	
	
	
}
