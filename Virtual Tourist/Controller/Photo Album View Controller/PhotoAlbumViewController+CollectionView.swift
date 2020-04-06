//
//  PhotoAlbumViewController+CollectionView.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 4/2/2003.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import UIKit

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		let sections = fetchedResultsController.sections ?? []

		return sections.isEmpty ? 0 : 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0

		return count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell

		let currentPhoto = fetchedResultsController.object(at: indexPath)

		cell.photo = currentPhoto
		cell.setUpPhotoCell()

		DispatchQueue.main.async {
			do {
				try DataController.shared.viewContext.save()
			} catch {
				print("Unable to save photo from flickr")
			}
		}

		return cell

	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let photo = fetchedResultsController.object(at: indexPath)

		performSegue(withIdentifier: "showPhotoDetails", sender: photo)
	}


	/// Set up the Collection View.
	func setUpCollectionView() {
		// Set up Collection View
		collectionView.dataSource = self
		collectionView.delegate = self
		configureFlowLayout()
	}

	/// Set up the flow layout for the Collection View.
	func configureFlowLayout() {
		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			let cellSideLength = (collectionView.frame.width/3) - 1
			flowLayout.itemSize = CGSize(width: cellSideLength, height: cellSideLength)
		}
	}
}
