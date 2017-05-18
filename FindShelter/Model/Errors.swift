 //
//  Errors.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-12.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

public struct Errors {
	
	private init() {}
	
	static func new(code: Int, comment: String? = nil) -> NSError {
		let message = errorMessage(errorCode: code, comment: comment)
		
		let userInfo = [NSLocalizedDescriptionKey: message["message"]! as Any,
		                NSLocalizedFailureReasonErrorKey: message["comment"] as Any
		                ]
		let error = NSError(domain: message["domain"]!, code: code, userInfo: userInfo)
		return error
	}
}

// MARK: - Error codes
private extension Errors {
	
	static func errorMessage(errorCode code: Int, comment: String? = nil) -> [String: String] {
		
		var errorInfo: [String: String] = [:]
		var message: String = ""
		
		if code >= 100 && code <= 199 {
			errorInfo["domain"] = "serverRequestError"
			switch code {
			case 100 : message = "Server did not return any status code."
			case 101 : message = "Server returned 1xx - Informal response."
			case 103 : message = "Server returned 3xx - Redirection respone."
			case 104 : message = "Server returned 4xx - Client error response."
			case 105 : message = "Server returned 5xx - Server error response."
			case 110 : message = "No data was returned."
			default  : message = "Unknown server request error."
			}
		}
		
		if code >= 200 && code <= 299 {
			errorInfo["domain"] = "jsonParsingError"
			
			switch code {
			case 200 : message = "JSON parsing failed."
			default: message = "Unknown parsing error."
			}
		}
		
		if code >= 400 && code <= 499 {
			errorInfo["domain"] = "coreDataError"
			
			switch code {
			case 401 : message = "Unable to find model in the main bundle"
			case 402 : message = "Unable to create model from URL"
			case 403 : message = "Unable to reach document folder"
			case 404 : message = "Unable to add store at URL"
			case 405 : message = "Error while autosaving"
			default  : message = "Core Data error"
			}
		}
		
		if code >= 500 && code <= 599 {
			errorInfo["domain"] = "resultsError"
			
			switch code {
			case 501 : message = "The search query did not return any results"
			case 502 : message = "Cannot unwrap coordinates from ShelterObject"
			default  : message = "Unknown result error"
			}
		}
		
		errorInfo["message"] = message
		
		if comment != nil {
			errorInfo["comment"] = comment!
		}
		
		return errorInfo
	}
}
