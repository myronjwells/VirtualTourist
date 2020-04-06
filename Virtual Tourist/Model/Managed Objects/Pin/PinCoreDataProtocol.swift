//
//  PinCoreDataProtocol.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/20/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

/// Utility for managing pin managed objects.
protocol PinCoreDataProtocol {
	/// Creates and persists a pin object.
	/// - Parameters:
	///     - context: the managed object context used to persist the pin.
	///     - location: the name of the location associated with the pin.
	///     - coordinate: the coordinates of the pin.
	/// - Returns: the created pin object.
	func createPin(usingContext context: NSManagedObjectContext, withLocation location: String?, andCoordinate coordinate: CLLocationCoordinate2D) -> Pin

	/// Deletes the specified pin object.
	/// - Parameters:
	///		- pin: the pin that will be deleted.
	///     - context: the NSManagedObjectContext responsible for the pin.
	func deletePin(pin: Pin, fromContext context: NSManagedObjectContext)
}
