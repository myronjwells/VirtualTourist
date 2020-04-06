//
//  PhotoDetailViewController.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/25/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import CoreData


/// Displays details about the selected photo from the PhotoAlbumViewController
class PhotoDetailViewController: UIViewController {

	//MARK:- IBOutlets
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var imageTitle: UILabel!
	@IBOutlet weak var url: UIButton!
	@IBOutlet weak var imageHeight: UILabel!
	@IBOutlet weak var imageWidth: UILabel!

	//MARK:- Controller properties
	var fetchedResultsViewController: NSFetchedResultsController<Photo>!
	var fetchedResultsViewControllerDelegate: NSFetchedResultsControllerDelegate!
	var photo: Photo!

	//MARK:- View lifecycle methods
	override func viewDidLoad() {
		super.viewDidLoad()

		guard let imageData = photo.imageData else {
			self.presentErrorAlert(title: "Unable to load photo details", message: "Please try again")
			fatalError("No image data passed to photo view controller")
		}

		imageView.image = UIImage(data: imageData)
		imageTitle.text = photo.title ?? "Untitled"
		url.setTitle(photo.url?.absoluteString, for: .normal)
		imageHeight.text = photo.height
		imageWidth.text = photo.width
	}

	//MARK:- IBActions
	@IBAction func urlButtonPressed(_ sender: UIButton) {
		let app = UIApplication.shared
		if let toOpen = photo.url {
			app.open(toOpen, options: [:], completionHandler: nil)
		}
	}

	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
		dismiss(animated: true) {
			self.fetchedResultsViewController.managedObjectContext.delete(self.photo)
		}
	}
}
