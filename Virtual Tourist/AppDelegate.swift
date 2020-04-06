//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Myron Wells on 3/18/20.
//  Copyright © 2020 Myron Wells. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Set up the data controller
		DataController.shared.load()

		return true
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		try? DataController.shared.save()
	}

	func applicationWillTerminate(_ application: UIApplication) {
		try? DataController.shared.save()
	}


}

