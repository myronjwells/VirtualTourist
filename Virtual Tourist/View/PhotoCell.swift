//
//  CollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/25/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import CoreData


/// Class representation of the PhotoAlbumViewController's Collection View Cells.
class PhotoCell: UICollectionViewCell {

	// MARK:- IBActions
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var imageView: UIImageView!

	// MARK:- Class Properties
	public static let reuseId = "photoCell"
	var photo: Photo!

	// MARK:- Class Methods
	/// Set up the cell's imageView by downloading or reusing photos that have already been downloaded.
	func setUpPhotoCell() {
		if #available(iOS 13.0, *) {
			activityIndicator.style = .large
		} else {
			activityIndicator.style = .whiteLarge
		}

		activityIndicator.startAnimating()

		// Populate cell imageview
		if let data = photo.imageData {
			// Photo data already exists in photo object. But has not yet been converted to a UIImage
			let image = UIImage(data: data)
			imageView.image = image
			activityIndicator.stopAnimating()
		} else {
			// No photo currently downloaded. Request image from flickr
			activityIndicator.startAnimating()
			FlickrClient.shared.downloadImage(fromUrl: photo.url!) { [weak self] (imageData, url, error) in
				guard let weakSelf = self else { return }

				guard let imageData = imageData else { preconditionFailure("Unable to download image: \(error.debugDescription)") }

				DispatchQueue.main.async {
					if url != weakSelf.photo.url?.absoluteString {
						return
					}

					weakSelf.photo.imageData = imageData.jpegData(compressionQuality: 1)
					weakSelf.imageView.image = imageData
					weakSelf.activityIndicator.stopAnimating()
				}
			}
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		self.imageView.image = UIImage()
		self.activityIndicator.startAnimating()
	}
}
