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
        
        
        //TODO: Save All models with coredata
        //TODO: persist the spot user zoomed to with NSUserdefaults
        //TODO: See if there is any multi threading backend stuff needed for downloading pictures/making network calls in the longpress function
        //TODO: figure out a way to delete pins
        //TODO: Extra- consider making a tutorial view for the different viewcontrollers?
        //TODO: Consider moving the photoCount, page, and pages out of Pin model into its own data model.
              

        
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
        
        
        
        //TODO: Refactor this code into its own method later
        
        FlickrClient.getPhotos(lat: myCoordinate.latitude, long: myCoordinate.longitude) { (photosParser, error) in
            
            if let photosParser = photosParser {
                
                if photosParser.photos.pages > 0 {
                    
                    // Added pins to MapView.
                    DispatchQueue.main.async {
                        // Generate pins.
                        
                        let pin = Pin(context: self.dataController.viewContext)
                        pin.latitude = myCoordinate.latitude
                        pin.longitude = myCoordinate.longitude
                        pin.title = "Open Photo Album"
                        pin.photoCount = photosParser.photos.total
                        pin.pageNumber = Int32(photosParser.photos.page)
                        pin.totalPages = Int32(photosParser.photos.pages)
                        self.mapView.addAnnotation(pin)
                        
                        // create Photo Object and add to Pin
                        for flickrPhoto in photosParser.photos.photo {
                            let photo = Photo(context: self.dataController.viewContext)
                            
                            if let flickrImageURL = flickrPhoto.mediumUrl {
                                
                                let imageURL = URL(string: flickrImageURL)
                                photo.url = flickrImageURL
                                self.downloadImage(from: imageURL!) { imageData  in
                                    guard let imageData = imageData else { return }
                                    photo.image = imageData
                                }
                                
                                pin.addToPhotos(photo)
                            }
                            
                        }
                        
                        
                        //                        func addNote() {
                        //                            let note = Note(context: dataController.viewContext)
                        //                            note.creationDate = Date()
                        //                            note.notebook = notebook
                        //                            try? dataController.viewContext.save()
                        //                        }
                        
                    }
                } else {
                    print("Alert:There are no photos set for this location")
                }
            }
            
        }
        
    }
    
    func downloadImage(from url: URL,completion: @escaping (Data?) -> Void) {
        print("Download Started")
        FlickrClient.getData(from: url) { data, response, error in
            guard let data = data, error == nil
                else {
                    completion(nil)
                    return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
            completion(data)
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = annotation as! Pin
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.animatesDrop = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let photoCountbutton = UIButton(type: .roundedRect)
            photoCountbutton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            photoCountbutton.setTitle(pin.photoCount, for: .normal)
            photoCountbutton.setTitleColor(.white, for: .normal)
            photoCountbutton.backgroundColor = UIColor.blue
            
            pinView?.rightCalloutAccessoryView = photoCountbutton
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
            
            let photoAlbumViewController = self.storyboard?.instantiateViewController(withIdentifier: "photoAlbumViewController") as! PhotoAlbumViewController
            photoAlbumViewController.pin = view.annotation as? Pin
            photoAlbumViewController.dataController = dataController
            self.navigationController?.pushViewController(photoAlbumViewController, animated: true)
            
        }
    }
    
}

