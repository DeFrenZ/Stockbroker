//
//  GCDExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Foundation.NSThread
import Dispatch



func dispatch_sync_main(block: dispatch_block_t) {
	if NSThread.currentThread().isMainThread {
		block()
	} else {
		dispatch_sync(dispatch_get_main_queue(), block)
	}
}
