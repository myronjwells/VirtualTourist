//
//  Album.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/19/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import CoreData


/// Photo Album Core Data Managed Object
class PhotoAlbum: NSManagedObject {
	var isEmpty: Bool {
		return (photos?.count ?? 0) == 0
	}

	override func awakeFromInsert() {
		super.awakeFromInsert()
		dateCreated = Date()
		id = UUID().uuidString
	}
}
