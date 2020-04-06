//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 4/2/2003.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {

	//MARK:- IBOutlets
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	@IBOutlet weak var deleteButton: UIBarButtonItem!
	@IBOutlet weak var navBarItem: UINavigationItem!
	@IBOutlet weak var newCollectionButton: UIBarButtonItem!
	
	//MARK:- Controller Properties
	var albumStatusView: AlbumStatusView!
	var fetchedResultsController: NSFetchedResultsController<Photo>!
	var pin: Pin!
	var blockOperations: [BlockOperation] = []

	//MARK:- View Lifecycle methods
	override func viewDidLoad() {
		super.viewDidLoad()

		guard let pin = pin, let album = pin.album else {
			presentErrorAlert(title: "Unable to load photo album", message: "Please try again later.")
			fatalError("No pin passed to photo album view controller")
		}

		navBarItem.title = pin.locationName ?? "Album"

		setUpMapView()
		setUpCollectionView()
		setUpButtons(enabled: false)
		setUpAlbumStatusView()

		if album.isEmpty {
			downloadPhotos()
		} else {
			albumStatusView.setState(state: .displayImages)
			setUpButtons(enabled: true)
		}

		fetchedResultsController = PhotoCoreData.shared.getFetchedResultsController(forAlbum: album, fromContext: DataController.shared.viewContext)
		fetchedResultsController.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configureFlowLayout() 

		refreshPhotos()

		collectionView.reloadData()
	}


	//MARK:- Class Methods
	func downloadPhotos(forPage page: Int = 1){
		albumStatusView.setState(state: .downloading)

		FlickrClient.shared.getFlickrPhotos(forPin: pin, resultsForPage: page) {[weak self] (pin, pages, error) in
			guard let weakSelf = self else { return }
			guard error == nil, let pin = pin else {
				weakSelf.presentErrorAlert(title: "Unable to download images", message: error!.localizedDescription)
				weakSelf.albumStatusView.setState(state: .noImagesFound)
				return
			}
			guard let album = pin.album else { weakSelf.presentErrorAlert(title: "Unable to download images", message: error!.localizedDescription)
				weakSelf.albumStatusView.setState(state: .noImagesFound)
				return
			}

			if album.isEmpty {
				weakSelf.albumStatusView.setState(state: .noImagesFound)
			} else {
				weakSelf.albumStatusView.setState(state: .displayImages)
				weakSelf.refreshPhotos()
			}
			weakSelf.setUpButtons(enabled: true)
		}
	}

	/// Fetch album from core data and reload the collection view.
	fileprivate func refreshPhotos(){

		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError("Unable to fetch photos: \(error.localizedDescription)")
		}

		collectionView.reloadData()
	}

	/// Set Up the initial AlbumStatusView.
	fileprivate func setUpAlbumStatusView() {
		albumStatusView = AlbumStatusView(frame: self.collectionView.frame)
		albumStatusView.setState(state: .downloading)
		self.view.addSubview(albumStatusView)
	}

	/// Set the new collection button and delete button funtionality.
	/// - Parameter enabled: Enable or disable the buttons.
	fileprivate func setUpButtons(enabled: Bool){
		deleteButton.isEnabled = enabled
		newCollectionButton.isEnabled = enabled
	}

	//MARK:- IBActions
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}


	@IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
		PinCoreData.shared.deletePin(pin: self.pin, fromContext: DataController.shared.viewContext)
		dismiss(animated: true, completion: nil)
	}

	@IBAction func newCollectionButtonPressed(_ sender: UIBarButtonItem) {
		guard let album = pin.album else { return }
		guard album.totalPages > 1 else {
			presentErrorAlert(title: "Unable to fetch new photos", message: "There are no additional photos available for the given location.")
			return
		}

		newCollectionButton.isEnabled = false
		albumStatusView.setState(state: .downloading)

		fetchedResultsController.fetchedObjects?.forEach { (photo) in
			DataController.shared.viewContext.delete(photo)
		}
		
		do {
			try DataController.shared.viewContext.save()
		} catch {
			print("Unable to save context after clearing album")
		}

		let currentPage = Int(album.currentPage)
		let totalPages = Int(album.totalPages)

		var nextPage: Int

		// If the randomly generated number happens to be the same page as current, get a different random number.
		repeat {
			nextPage = Int.random(in: 1...totalPages)
		} while nextPage == currentPage

		downloadPhotos(forPage: nextPage)
	}

	//MARK:- Prepare for Segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let photo = sender as! Photo
		let destinationVC = segue.destination as! PhotoDetailViewController

		destinationVC.photo = photo
		destinationVC.fetchedResultsViewController = fetchedResultsController
		destinationVC.fetchedResultsViewControllerDelegate = self
	}

}
