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
	static private let apiKey: String = "5577ecaa27f974815b3b"
	private var channelsByName: [String: PTPusherChannel] = [:]
	
	override init() {
		super.init()
		client = PTPusher(key: PusherManager.apiKey, delegate: self, encrypted: true)
		client.connect()
	}
	func subscribeToEvent(eventName: String, onChannel channelName: String, withBlock block: JSON -> ()) {
		channelsByName[channelName] ??= client.subscribeToChannelNamed(channelName)
		guard let channel = channelsByName[channelName] else { fatalError("No Pusher channel created") }
		channel.bindToEventNamed(eventName) { event in
			guard
				let eventPayload = event.data,
				let json = try? JSON(foundationObject: eventPayload)
			else {
				print("Event error:", event)
				return
			}
			block(json)
		}
	}
}

//MARK: - PTPusherDelegate
extension PusherManager: PTPusherDelegate {
	
}
