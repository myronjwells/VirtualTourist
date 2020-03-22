//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Myron Wells on 3/18/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            //TODO: Test
        
               // Generate long-press UIGestureRecognizer.
               let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
               myLongPress.addTarget(self, action: #selector(recognizeLongPress(_:)))
               
               // Added UIGestureRecognizer to MapView.
               mapView.addGestureRecognizer(myLongPress)
    }
    
    // A method called when long press is detected.
       @objc private func recognizeLongPress(_ sender: UILongPressGestureRecognizer) {
           // Do not generate pins many times during long press.
        if sender.state != UIGestureRecognizer.State.began {
               return
           }
           
           // Get the coordinates of the point you pressed long.
           let location = sender.location(in: mapView)
           
           // Convert location to CLLocationCoordinate2D.
           let myCoordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        
        
            let pin = Pin(context: dataController.viewContext)
            pin.latitude = myCoordinate.latitude
            pin.longitude = myCoordinate.longitude
           
           // Generate pins.
           let annotation: MKPointAnnotation = MKPointAnnotation()
           
           // Set the coordinates.
           annotation.coordinate = myCoordinate
           mapView.addAnnotation(annotation)
        
//        FlickrClient.getPhotos(lat: pin.latitude, long: pin.longitude) { (photosParser, error) in
//
//            if let photosParser = photosParser {
//
//                if photosParser.photos.pages > 0 {
//
//                    // Added pins to MapView.
//                    DispatchQueue.main.async {
//                        self.mapView.addAnnotation(annotation)
//                    }
//                } else {
//                    print("There are no photos set for this location")
//                }
//            }
//
//        }
        
       }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.animatesDrop = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: {
                    (success) in
                    print("Open \(toOpen): \(success)")
                })
            }
            
        }
    }

}

