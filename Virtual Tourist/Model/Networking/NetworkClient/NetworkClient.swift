//
//  NetworkClient.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/21/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

struct NetworkClient: NetworkClientProtocol {
	static let shared: NetworkClient = NetworkClient()

	private init() {}

	func createGetRequest(
		withUrl baseUrl: URL,
		queryParms: [String : String],
		headers: [String : String]?,
		completionHandler: @escaping (Data?, Error?) -> Void
	) -> URLSessionDataTask {
		guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else { preconditionFailure("Failed to Build URLComponents from: \(baseUrl)") }

		urlComponents.queryItems = queryParms.map{ (key, value) in
			URLQueryItem(name: key, value: value)
		}

		var urlRequest = URLRequest(url: urlComponents.url!)

		urlRequest.httpMethod = HTTPMethods.get

		if let headers = headers {
			headers.forEach { (key, value) in
				urlRequest.addValue(value, forHTTPHeaderField: key)
			}
		} else {
			urlRequest.addValue(HeaderValues.contentType, forHTTPHeaderField: HeaderKeys.contentType)
			urlRequest.addValue(HeaderValues.accept, forHTTPHeaderField: HeaderKeys.accept)
		}

		return URLSession.shared.dataTask(with: urlRequest){ (data, urlResponse, error) in
			guard let data = data, error == nil else {
				completionHandler(nil, error)
				return
			}

			completionHandler(data, nil)
		}
	}
}
