//
//  UIKitExtensions.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit



//MARK: - UIViewController
extension UIViewController {
	func updateUIWithBlock(block: () -> ()) {
		guard isViewLoaded() else { return }
		dispatch_sync_main(block)
	}
}
