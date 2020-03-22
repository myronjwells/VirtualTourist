//
//  PhotosModel.swift
//  VirtualTourist
//
//  Created by Myron Wells on 3/20/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
struct PhotosParser: Codable {
    let photos: Photos
}
struct Photos: Codable {
    let pages: Int
    let photo: [PhotoParser]
    let total: String
}
struct PhotoParser: Codable {
    
    let mediumUrl: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case mediumUrl = "url_m"
        case title
    }
}
