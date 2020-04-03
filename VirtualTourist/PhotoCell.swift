//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Myron Wells on 3/30/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectIndicator: UIImageView!
    @IBOutlet weak var highlightIndicator: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            selectIndicator.isHidden = !isSelected
        }
    }
}
