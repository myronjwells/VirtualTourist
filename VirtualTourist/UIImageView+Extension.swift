//
//  UIImageView+Extension.swift
//  VirtualTourist
//
//  Created by Myron Wells on 4/2/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        
        let url = URL(string: urlString)
        
        
        image = nil
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }.resume()
    }
}
