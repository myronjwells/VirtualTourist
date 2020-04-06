//
//  UIViewController+Extensions.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/28/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

	/// Reusable method for presenting a standard Error Alert.
	/// - Parameter title: Title Bar Message.
	/// - Parameter message: More detailed body message.
	func presentErrorAlert(title: String, message: String){
		let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alertVC, animated: true, completion: nil)
	}
}
