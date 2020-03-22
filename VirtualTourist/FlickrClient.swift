//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Myron Wells on 3/19/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation

class FlickrClient {
    
    enum GETParams {
        static let apiKey = "bae4da7596bed634e029ddc1c7c3bdd6"
        static let photoSearchMethod = "flickr.photos.search"
        static let format = "json"
        static let noJSONcallBack = 1
    }
    
    enum OptionalParams {
        static let latitude = "lat"
        static let longitutde = "lon"
        static let perPage = "per_page"
        static let page = "page"
        static let extras = "extras"
    }
    
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/"
        
        case getPhotos
        
        var stringValue: String {
            switch self {
            case .getPhotos:
                return Endpoints.base + "?method=\(GETParams.photoSearchMethod)&api_key=\(GETParams.apiKey)&format=\(GETParams.format)&nojsoncallback=\(GETParams.noJSONcallBack)"
            }
        }
        
        var urlComp: URLComponents {
            return URLComponents(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(urlComp: URLComponents, params: [String: Any], responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        var urlcomp = urlComp
        //Add optional params into the url if they are available
        var items = [URLQueryItem]()
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty {
            urlcomp.queryItems?.append(contentsOf: items)   
        }
        
        print("URL: \(urlcomp.url!)")
        let task = URLSession.shared.dataTask(with: urlcomp.url!) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if (String(data: data, encoding: .utf8)?.hasPrefix(")"))! {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func getPhotos(lat: Double, long: Double, imageURLType: String = "url_m", page: Int = 1, perPage: Int = 50, completion: @escaping (PhotosParser?, Error?) -> Void) {
        taskForGETRequest(urlComp: Endpoints.getPhotos.urlComp, params: [OptionalParams.latitude: lat, OptionalParams.longitutde: long, OptionalParams.extras: imageURLType, OptionalParams.page: page, OptionalParams.perPage: perPage], responseType: PhotosParser.self) { response, error in
            if let response = response {
                completion(response,nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
