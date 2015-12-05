//
//  UIKitExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit



//MARK: - UIResponder
extension UIResponder {
	func performActionOnResponderChain(action: Selector, withObject object: NSObject? = nil) -> Bool {
		guard let responder = targetForAction(action, withSender: object) else { return false }
		responder.performSelector(action, withObject: object)
		return true
	}
}

//MARK: - UIViewController
extension UIViewController {
	func updateUIWithBlock(block: () -> ()) {
		guard isViewLoaded() else { return }
		dispatch_sync_main(block)
	}
}
