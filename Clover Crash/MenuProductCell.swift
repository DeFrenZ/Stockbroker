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
	
	var productIdentifier: UInt?
	@IBOutlet private var sideView: UIView!
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var priceLabel: UILabel!
	@IBOutlet private var percentageLabel: UILabel!
}

//MARK: - UI
extension MenuProductCell {
	private static let priceFormatter: NSNumberFormatter = {
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .CurrencyStyle
		return formatter
	}()
	private static let percentageFormatter: NSNumberFormatter = {
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .PercentStyle
		return formatter
	}()
	private static func colorForPercentage(percentage: NSDecimal) -> UIColor {
		switch percentage {
		case _ where percentage > 0: return .redColor()
		case 0: return .blueColor()
		case _ where percentage < 0: return .greenColor()
		default: fatalError("Switch should go here")
		}
	}
	
	func setName(name: String) {
		dispatch_sync_main {
			self.nameLabel.text = name
		}
	}
	func setPrice(price: NSDecimal) {
		dispatch_sync_main {
			self.priceLabel.text = MenuProductCell.priceFormatter.stringFromNumber(NSDecimalNumber(decimal: price))
		}
	}
	func setPercentage(percentage: NSDecimal) {
		dispatch_sync_main {
			let percentageColor = MenuProductCell.colorForPercentage(percentage)
			self.sideView.backgroundColor = percentageColor
			self.percentageLabel.text = MenuProductCell.percentageFormatter.stringFromNumber(NSDecimalNumber(decimal: percentage))
			self.percentageLabel.textColor = percentageColor
		}
	}
}

//MARK: - IBAction
extension MenuProductCell {
	static var selectedProductWithIdentifierActionName: Selector { return Selector("selectedProductWithIdentifier:") }
	@IBAction private func orderButtonTapped(sender: UIButton) {
		guard let productIdentifier = productIdentifier else { return }
		performActionOnResponderChain(MenuProductCell.selectedProductWithIdentifierActionName, withObject: NSNumber(unsignedInteger: productIdentifier))
	}
}
