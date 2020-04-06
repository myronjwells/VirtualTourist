//
//  PhotoCoreDataProtocol.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/20/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import CoreData

/// Utility for Creating Photo Managed Object
protocol PhotoCoreDataProtocol {
	/// Creates a new Photo NSManagedObject
	/// - Parameters:
	/// 	- flickrImage: flickr image to be persisted.
	/// 	- album: the album associted with the image.
	func createPhoto(flickrImage: FlickrImage, inAlbum album: PhotoAlbum) -> Photo

	/// Retrieve Fetched results controller for the associated album.
	/// - Parameters:
	/// 	- photoAlbum: the album that photos will be retrieved from.
	///		- context: the managed object context to be fetched.
	/// - Returns: the fetched results controller.
	func getFetchedResultsController(forAlbum album: PhotoAlbum, fromContext context: NSManagedObjectContext) -> NSFetchedResultsController<Photo>
}
