//
//  NetworkClient+Constants.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/21/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

extension NetworkClient {
	enum HeaderKeys {
		static let contentType = "Content-Type"
		static let accept = "Accept"
	}

	enum HeaderValues {
		static let contentType = "application/json"
		static let accept = "application/json"
	}

	enum HTTPMethods{
		static let get = "GET"
	}
}
