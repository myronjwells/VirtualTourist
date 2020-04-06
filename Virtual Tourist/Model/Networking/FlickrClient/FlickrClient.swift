//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/19/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import UIKit

class FlickrClient: FlickrClientProtocol {
	private let baseURL: URL = URL(string: API.BaseUrl)!

	private static let jsonDecoder = JSONDecoder()

	static let shared = FlickrClient()

	private init(){}

	func getFlickrPhotos(forPin pin: Pin, resultsForPage page: Int = 1, completionHandler: @escaping (Pin?, Int?, Error?) -> Void) {
		let pinId = pin.objectID

		requestImages(forPin: pin, resultsForPage: page) { (data, error) in
			guard let data = data, error == nil else {
				DispatchQueue.main.async {
					completionHandler(nil, nil, error)
				}
				return
			}

			let pinContext = DataController.shared.viewContext.object(with: pinId) as! Pin

			DispatchQueue.main.async {
				do {
					try PhotoAlbumCoreData.shared.setPagingInformation(currentPage: Int16(data.searchResults.page), totalPages: Int16(data.searchResults.pages), forAlbum: pinContext.album!)
					try PhotoAlbumCoreData.shared.addPhotos(images: data.searchResults.photos, toPhotoAlbum: pinContext.album!)
					completionHandler(pin, data.searchResults.pages, nil)
				} catch {
					completionHandler(nil, nil, error)
				}
			}
		}
	}

	func requestImages(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (FlickrResponse?, Error?) -> Void) {
		let queryParms = [
			ParameterKeys.APIKey: ParameterDefaultValues.APIKey,
			ParameterKeys.Format: ParameterDefaultValues.Format,
			ParameterKeys.NoJsonCallback: ParameterDefaultValues.NoJsonCallback,
			ParameterKeys.Method: Methods.PhotosSearch,
			ParameterKeys.Extra: ParameterDefaultValues.ExtraMediumURL,
			ParameterKeys.Page: String(page),
			ParameterKeys.RadiusUnits: ParameterDefaultValues.RadiusUnits,
			ParameterKeys.Radius: ParameterDefaultValues.Radius,
			ParameterKeys.ResultsPerPage: ParameterDefaultValues.ResultsPerPage,
			ParameterKeys.Sort: ParameterDefaultValues.Sort,
			ParameterKeys.Latitude: String(pin.latitude),
			ParameterKeys.Longitude: String(pin.longitude)
		]

		let dataTask = NetworkClient.shared.createGetRequest(withUrl: baseURL, queryParms: queryParms, headers: nil) { (data, error) in

			guard let data = data, error == nil else {
				completionHandler(nil, error)
				return
			}

			let jsonDecoder = JSONDecoder()

			do {
				let flickrResponse = try jsonDecoder.decode(FlickrResponse.self, from: data)
				completionHandler(flickrResponse, nil)
			} catch {
				do {
					let flickrError = try jsonDecoder.decode(FlickrErrorResponse.self, from: data)
					completionHandler(nil, flickrError)
				} catch {
					completionHandler(nil, error)
				}
			}
			
		}
		dataTask.resume()
	}

	func downloadImage(fromUrl url: URL, completionHandler: @escaping (UIImage?, String?, Error?) -> Void) {
		let dataTask = NetworkClient.shared.createGetRequest(withUrl: url, queryParms: [:], headers: [:]) { (data, error) in
			guard let data = data, error == nil else {
				completionHandler(nil, nil, error)
				return
			}

			guard let image = UIImage(data: data) else {
				completionHandler(nil, nil, error)
				return
			}

			completionHandler(image, url.absoluteString, nil)
		}
		dataTask.resume()
	}
}
