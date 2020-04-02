//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Myron Wells on 3/18/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    var pin: Pin!
    var dataController: DataController!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Save All models with coredata
        //TODO: delete images and save persist the changes
        //TODO: Make new collection button that randomizes the page from request call ( probably a refresh icon)
        //TODO: Add placeholder image to the photos if they arent downloaded yet ( this might only show up when you refresh the collection) 
    }
    
    @IBAction func loadNewCollection(_ sender: Any) {
        
       //Get random page number from the total amount of pages
        let randomPage = Int.random(in: 1...Int(pin.totalPages))

        
//        FlickrClient.getPhotos(lat: pin.latitude, long: pin.longitude, page: randomPage) { (photoParser, error) in
//            pin.photos = photoParser?.photos.photo
//        }
        
        FlickrClient.getPhotos(lat: pin.latitude, long: pin.longitude, page: randomPage) { (photosParser, error) in
            
            if let photosParser = photosParser {
                
                self.pin.removeFromPhotos(self.pin.photos!)
                
                // create Photo Object and add to Pin
                for flickrPhoto in photosParser.photos.photo {
                    let photo = Photo(context: self.dataController.viewContext)
                    
                    if let flickrImageURL = flickrPhoto.mediumUrl {
                        
                        let imageURL = URL(string: flickrImageURL)
                        
                        photo.url = flickrImageURL
                        
//                        self.downloadImage(from: imageURL!) { imageData  in
//                            guard let imageData = imageData else { return }
//                            photo.image = imageData
//                        }
                        
                        DispatchQueue.main.async {
                           self.pin.addToPhotos(photo)
                        }
                        
                       
                    }
                    
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                 
            }
        }
        
        
        
    }

    @IBAction func editTapped(_ sender: Any) {
    }
    @IBAction func deletePhotos(_ sender: Any) {
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return pin.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        if let _ = pin.photos {
            //let placeHolderImageData = (UIImage(named: "imagePlaceholder")!.jpegData(compressionQuality: 1.0))!
            let photosArray = pin.photos!.allObjects as! [Photo]
            cell.imageView.loadImageUsingUrlString(urlString: photosArray[indexPath.row].url!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 130)
    }
}
