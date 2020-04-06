//
//  FlickrErrorResponse.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 4/2/2020.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation


/// Error response struct from the Flickr API.
struct FlickrErrorResponse: Codable {
	let status: String
	let code: Int
	let message: String

	enum CodingKeys: String, CodingKey {
		case status = "stat"
		case code
		case message
	}
}

extension FlickrErrorResponse: LocalizedError {
	var errorDescription: String? {
		return self.message
	}
}
