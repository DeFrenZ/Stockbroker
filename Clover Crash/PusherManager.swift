//
//  PusherManager.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Foundation
import Pusher



final class PusherManager: NSObject {
	private var client: PTPusher!
	static private let apiKey: String = "f93950db757aaa7c02c2"
	
	override init() {
		super.init()
		client = PTPusher(key: PusherManager.apiKey, delegate: self, encrypted: true)
	}
}

//MARK: - PTPusherDelegate
extension PusherManager: PTPusherDelegate {
	
}
