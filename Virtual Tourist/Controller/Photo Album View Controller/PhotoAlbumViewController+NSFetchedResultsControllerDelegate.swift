//
//  PhotoAlbumViewController+NSFetchedResultsControllerDelegate.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/27/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import CoreData

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		blockOperations.removeAll(keepingCapacity: false)
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		collectionView!.performBatchUpdates(
			{ () -> Void in
				self.blockOperations.forEach { (blockOp) in
					blockOp.start()
				}
			}
		) { (finished) -> Void in
			self.blockOperations.removeAll(keepingCapacity: false)
			self.collectionView.reloadData()
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

		var op: BlockOperation!

		switch type {
		case .insert:
			op = BlockOperation { [weak self] in
				if let weakSelf = self {
					weakSelf.collectionView!.insertItems(at: [newIndexPath!])

				}
			}
		case.delete:
			op = BlockOperation { [weak self] in
				if let weakSelf = self {
					weakSelf.collectionView!.deleteItems(at: [indexPath!])
				}
			}
		case.update:
			op = BlockOperation { [weak self] in
				if let weakSelf = self {
					weakSelf.collectionView!.reloadItems(at: [indexPath!]) }
				}
		case.move:
			op = BlockOperation { [weak self] in
				if let weakSelf = self {
					weakSelf.collectionView!.moveItem(at: indexPath!, to: newIndexPath!)
				}
			}
		@unknown default:
			break
		}

		blockOperations.append(op)
	}
}
