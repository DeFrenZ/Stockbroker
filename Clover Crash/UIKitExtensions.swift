//
//  UIKitExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit



//MARK: - UIColor
func interpolateRGBA(from from: UIColor, to: UIColor, by: CGFloat) -> UIColor {
	var fromRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
	from.getRed(&fromRGBA[0], green: &fromRGBA[1], blue: &fromRGBA[2], alpha: &fromRGBA[3])
	
	var toRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
	to.getRed(&toRGBA[0], green: &toRGBA[1], blue: &toRGBA[2], alpha: &toRGBA[3])
	
	let clampedBy = clamp(by, minimum: 0, maximum: 1)
	
	let interpolatedRGBA = zip(fromRGBA, toRGBA).map { $0 + ($1 - $0) * clampedBy }
	
	return UIColor(red:	interpolatedRGBA[0], green: interpolatedRGBA[1], blue: interpolatedRGBA[2],	alpha: interpolatedRGBA[3])
}

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
