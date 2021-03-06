//
//  CoreDataStack.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-10.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
	
	private let model        : NSManagedObjectModel
	internal let coordinator : NSPersistentStoreCoordinator
	private let modelUrl     : URL
	internal let dbUrl       : URL
	let persistingContext    : NSManagedObjectContext
	
	static let shared = CoreDataStack(modelName: "Model")
	
	// MARK: - Initializer
	init?(modelName: String) {
		
		guard let modelUrl = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
			debugPrint(Errors.new(code: 401, comment: "Unable to find \(modelName)"))
			return nil
		}
		
		self.modelUrl = modelUrl
		
		guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
			debugPrint(Errors.new(code: 402, comment: "Unable to create model from \(modelUrl)"))
			return nil
		}
		
		self.model = model
		
		coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		
		persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		persistingContext.persistentStoreCoordinator = coordinator
		
		let fileManager = FileManager.default
		
		guard let docUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			debugPrint(Errors.new(code: 403))
			return nil
		}
		
		self.dbUrl = docUrl.appendingPathComponent("model.sqlite")
		
		let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
		
		do {
			try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbUrl, options: options as [NSObject: AnyObject]?)
		} catch {
			debugPrint(error)
			debugPrint(Errors.new(code: 404, comment: "Unable to add store at \(dbUrl)"))
		}
	}
	
	func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options: [NSObject: AnyObject]?) throws {
		try coordinator.addPersistentStore(ofType: storeType, configurationName: configuration, at: storeURL, options: options)
	}
}

extension CoreDataStack {
	
	func save() {
		persistingContext.performAndWait {
			if self.persistingContext.hasChanges {
				do {
					try self.persistingContext.save()
					print("Saving context")
				} catch {
					debugPrint(error)
					fatalError("Error while saving persisting context")
				}
			}
		}
	}
	
	func autosave(_ delayInSeconds: Int) {
		
		if delayInSeconds > 0 {
			do {
				try self.persistingContext.save()
				print("Autosaving")
			} catch {
				debugPrint(error)
				debugPrint(Errors.new(code: 405))
			}
			
			let delayInNanoseconds = UInt64(delayInSeconds) * NSEC_PER_SEC
			let time = DispatchTime.now() + Double( Int64( delayInNanoseconds)) / Double(NSEC_PER_SEC)
			
			DispatchQueue.main.asyncAfter(deadline: time) {
				self.autosave(delayInSeconds)
			}
		}
	}
}
