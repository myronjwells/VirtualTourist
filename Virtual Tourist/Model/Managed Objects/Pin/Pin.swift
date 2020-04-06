//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/19/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import CoreData


/// Map Pin Core Data Managed Object
class Pin: NSManagedObject {
	override func awakeFromInsert() {
		super.awakeFromInsert()

		dateCreated = Date()
		album = PhotoAlbum(context: managedObjectContext!)
	}
}
