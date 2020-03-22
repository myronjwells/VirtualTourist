//
//  Pin+Extension.swift
//  VirtualTourist
//
//  Created by Myron Wells on 3/22/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import MapKit

extension Pin:MKAnnotation {
 public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
