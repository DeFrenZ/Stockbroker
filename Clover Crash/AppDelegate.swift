//
//  AppDelegate.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	static var sharedDelegate: AppDelegate {
		let sharedDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
		return sharedDelegate!
	}
	
	lazy var pusherManager: PusherManager = PusherManager()
	static var sharedPusherManager: PusherManager {
		return sharedDelegate.pusherManager
	}
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		return true
	}
}

let stockbrokerYellow = "#F4D100".toColor!
