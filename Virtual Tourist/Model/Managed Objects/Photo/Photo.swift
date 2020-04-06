//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/19/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import CoreData


/// Photo Core Data Managed Object
class Photo: NSManagedObject {
	override func awakeFromInsert() {
		super.awakeFromInsert()
		dateCreated = Date()
	}
}
