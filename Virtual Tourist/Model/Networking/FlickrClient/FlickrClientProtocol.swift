//
//  FlickrClientProtocol.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/21/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import UIKit


/// Flicker Client is used to work with Flickr's API.
protocol FlickrClientProtocol {
	/// Obtains photos from Flickr for a specified map pin.
	/// - Parameters:
	/// 	- pin: the map pin to be populated with photos.
	///		- page: the page to grab photos from. Each page contains up to 100 photos.
	///		- completionHandler: function that will be called following the compeltion of this method.
	func getFlickrPhotos(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (Pin?, Int?, Error?) -> Void)

	/// Given Flickr image URL, download the image from Flickr.
	/// - Parameters:
	///		- url: Image Url.
	///		- completionHandler: function that will be called following the completion of this method.
	func downloadImage(fromUrl url: URL, completionHandler: @escaping (UIImage?, String?, Error?) -> Void )
}
