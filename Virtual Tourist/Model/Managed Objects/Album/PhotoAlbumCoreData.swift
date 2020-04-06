//
//  PhotoAlbumCoreData.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/20/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

struct PhotoAlbumCoreData: PhotoAlbumCoreDataProtocol {
	static let shared = PhotoAlbumCoreData()

	func addPhotos(images: [FlickrImage], toPhotoAlbum photoAlbum: PhotoAlbum) throws {
		guard let context = photoAlbum.managedObjectContext else { preconditionFailure("Album does not have a context.") }

		images.forEach { (flickrImage) in
			_ = PhotoCoreData.shared.createPhoto(flickrImage: flickrImage, inAlbum: photoAlbum)
		}

		try context.save()
	}

	func setPagingInformation(currentPage: Int16, totalPages: Int16, forAlbum photoAlbum: PhotoAlbum) throws {
		guard let context = photoAlbum.managedObjectContext else {
			preconditionFailure("Album does not have a context.")
		}

		photoAlbum.currentPage = currentPage
		photoAlbum.totalPages = totalPages

		try context.save()
	}
}
