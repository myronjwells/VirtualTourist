//
//  PhotoCoreData.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/20/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import CoreData

struct PhotoCoreData: PhotoCoreDataProtocol {

	static let shared = PhotoCoreData()

	private init() {}

	func createPhoto(flickrImage: FlickrImage, inAlbum album: PhotoAlbum) -> Photo {
		guard let context = album.managedObjectContext else { preconditionFailure("Failed to get album context.") }

		let photo = Photo(context: context)
		photo.title = flickrImage.title
		photo.url = URL(string: flickrImage.mediumUrl)
		photo.id = flickrImage.id
		photo.photoAlbum = album
//TODO:- Error with flickr API not returning consistent data type. Add back when issue is fixed.
//		photo.height = flickrImage.height
//		photo.width = flickrImage.width

		return photo
	}

	func getFetchedResultsController(forAlbum album: PhotoAlbum, fromContext context: NSManagedObjectContext) -> NSFetchedResultsController<Photo> {

		let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
		let predicate = NSPredicate(format: "photoAlbum == %@", album)
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = [sortDescriptor]

		return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
	}


}
