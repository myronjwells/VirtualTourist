//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/19/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Used to manage core data in Virtual Tourist Application.
class DataController {
	let persistentContainer: NSPersistentContainer

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	static let shared = DataController(modelName: "VirtualTourist")

	private init(modelName: String) {
		persistentContainer = NSPersistentContainer(name: modelName)
	}


	/// Set up DataController context.
	/// - Parameter completionHandler: Code to execute after the completion of this method.
	func load(completionHandler: (() -> Void)? = nil) {
		persistentContainer.loadPersistentStores { storeDescription, error in
			guard error == nil else {
				fatalError(error!.localizedDescription)
			}
			self.autoSaveViewContext()

			self.configureContext()
			completionHandler?()
		}
	}


	/// Save current context.
	func save() throws {
		if viewContext.hasChanges {
			try viewContext.save()
		}
	}


	/// Configure the context merge policies.
	func configureContext() {
		viewContext.automaticallyMergesChangesFromParent = true
		viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
	}
}

// MARK: - Autosaving
extension DataController {
	private func autoSaveViewContext(interval: TimeInterval = 5) {
		guard interval > 0 else {
			print("cannot set negative autosave interval")
			return
		}

		if viewContext.hasChanges {
			try? viewContext.save()
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
			self.autoSaveViewContext(interval: interval)
		}
	}
}
