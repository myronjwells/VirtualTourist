//
//  PhotoAlbumViewController+MapView.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 4/2/2003.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import MapKit

extension PhotoAlbumViewController: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		let reuseId = "pin"

		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

		if pinView == nil {
			pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = false
			pinView!.markerTintColor = .blue
		} else {
			pinView!.annotation = annotation
		}

		pinView?.isSelected = true
		pinView?.isUserInteractionEnabled = false

		return pinView
	}


	/// Set up the MapView.
	func setUpMapView(){
		mapView.delegate = self
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		mapView.setRegion(region, animated: true)
		mapView.isInteractionEnabled(false)
		mapView.addAnnotation(AnnotationPinView(pin: pin))
	}
}
