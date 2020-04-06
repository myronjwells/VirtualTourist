//
//  AnnotationPinView.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/30/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import MapKit

/// Custom Annotation that can be created using a Pin managed object.
class AnnotationPinView: MKPointAnnotation {
	var pin: Pin

	init(pin: Pin){
		self.pin = pin
		super.init()
		self.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
	}
}


