//
//  MenuProductCell.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit



class MenuProductCell: UICollectionViewCell {
	static let reuseIdentifier: String = "MenuProductCell"
	
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var priceLabel: UILabel!
}

//MARK: - UI
extension MenuProductCell {
	private static let priceFormatter: NSNumberFormatter = {
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .CurrencyStyle
		return formatter
	}()
	
	func setImageWithURL(url: NSURL) {
		
	}
	func setName(name: String) {
		dispatch_sync_main {
			
		}
	}
	func setPrice(price: NSDecimal) {
		dispatch_sync_main {
			self.priceLabel.text = MenuProductCell.priceFormatter.stringFromNumber(NSDecimalNumber(decimal: price))
		}
	}
}
