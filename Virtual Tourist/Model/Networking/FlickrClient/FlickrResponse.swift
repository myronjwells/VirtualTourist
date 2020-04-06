//
//  FlickrResponse.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/19/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

/// Response struct from flickr photo search API.
struct FlickrResponse: Codable {
	let searchResults: SearchResults
	let status: String

	enum CodingKeys: String, CodingKey {
		case searchResults = "photos"
		case status = "stat"
	}
}

// Pagination metadata from Flickr photos search API.
struct SearchResults: Codable {
	let page: Int
	let pages: Int
	let photosPerPage: Int
	let totalPhotosCount: String
	let photos: [FlickrImage]

	enum CodingKeys: String, CodingKey {
		case page
		case pages
		case photosPerPage = "perpage"
		case totalPhotosCount = "total"
		case photos = "photo"
	}
}

/// Individual photo metadata from flickr API.
struct FlickrImage: Codable {
	let id: String
	let title: String
	let mediumUrl: String
//TODO:- Error with flickr API not returning consistent data type. Add back when issue is fixed.
//	let height: String
//	let width: String

	enum CodingKeys: String, CodingKey {
		case id
		case title
		case mediumUrl = "url_m"
//TODO:- Error with flickr API not returning consistent data type. Add back when issue is fixed.
//		case height = "height_m"
//		case width = "width_m"
	}
}

