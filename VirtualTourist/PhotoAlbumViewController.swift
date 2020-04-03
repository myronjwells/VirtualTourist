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
    
    
    enum Mode {
        case view
        case edit
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    var pin: Pin!
    var dataController: DataController!
    var mode: Mode = .view {
        didSet {
            switch mode {
            case .view:
                
                for (key,value) in dictionarySelectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                navigationItem.hidesBackButton = false
                navigationItem.leftBarButtonItem = nil
                navigationItem.rightBarButtonItems = [editButton,loadNewCollectionButton]
                editButton.title = "Edit"
                collectionView.allowsMultipleSelection = false
            case .edit:
                navigationItem.hidesBackButton = true
                navigationItem.leftBarButtonItem = deleteButton
                navigationItem.rightBarButtonItems = [editButton]
                editButton.title = "Done"
                collectionView.allowsMultipleSelection = true
                
            }
        }
    }
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    @IBOutlet  var editButton: UIBarButtonItem!
    @IBOutlet  var deleteButton: UIBarButtonItem!
    @IBOutlet  var loadNewCollectionButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Save All models with coredata
        //TODO: delete images and save persist the changes
        
        navigationItem.leftBarButtonItem = nil
        setupMap()

    }
    
    
    func setupMap() {
        let previewPin = MKPointAnnotation()
        previewPin.coordinate = pin.coordinate
        self.mapView.addAnnotation(previewPin)
        
        //Zooming in on annotation
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: previewPin.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
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
                        photo.url = flickrImageURL
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
        
        mode = mode == .view ? .edit : .view
    }
    @IBAction func deletePhotos(_ sender: Any) {
        
        var deleteNeededIndexPaths: [IndexPath] = []
        
        for(key,value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        for i in deleteNeededIndexPaths.sorted(by: {$0.item > $1.item}) {
            //            photosArray.remove(at: i.item) Need to figure how to delete from coredata
            
            let photosArray = (pin.photos?.allObjects as? [Photo])!
            pin.removeFromPhotos(photosArray[i.item])
        }
        
        collectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndexPath.removeAll()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
        case .edit:
            dictionarySelectedIndexPath[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if mode == .edit {
            dictionarySelectedIndexPath[indexPath] = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.reloadData()
        return CGSize(width: 130, height: 130)
    }
}
