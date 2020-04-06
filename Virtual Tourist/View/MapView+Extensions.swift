//
//  MapView+Extensions.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/22/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
	/// Set all map interaction on or off
	/// - Parameter enabled: Whether to enable or disable map interaction.
	func isInteractionEnabled(_ enabled: Bool) {
		isScrollEnabled = enabled
		isZoomEnabled = enabled
		isPitchEnabled = enabled
		isRotateEnabled = enabled
	}

	/// Add a pin managed object to the Map View.
	/// - Parameter pin: Pin Managed Object to be added.
	func addPinAnnotation(pin: Pin){
		addAnnotation(AnnotationPinView(pin: pin))
	}

	/// Clear all existing annotations from the map.
	func clearAnnotations(){
		removeAnnotations(annotations)
	}
}
