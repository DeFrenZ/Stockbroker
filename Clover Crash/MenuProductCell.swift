//
//  MenuProductCell.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit
import Charts



class MenuProductCell: UICollectionViewCell {
	static let reuseIdentifier: String = "MenuProductCell"
	
	var productIdentifier: String?
	@IBOutlet private var realContentView: UIView!
	@IBOutlet private var sideView: UIView!
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var priceLabel: UILabel!
	@IBOutlet private var percentageLabel: UILabel!
	@IBOutlet private var chartView: ChartViewBase!
}

//MARK: - NSObject
extension MenuProductCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		self.realContentView.layer.cornerRadius = 5
		self.layer.shadowOpacity = 0.05
		//self.layer.shadowColor = UIColor.blackColor().CGColor
		self.layer.shadowRadius = 3
		self.layer.shadowOffset = CGSize(width: 0, height: 2)
	}
}

//MARK: - UIView
extension MenuProductCell {
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.shadowPath = UIBezierPath(roundedRect: realContentView.frame, cornerRadius: layer.cornerRadius).CGPath
	}
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
	private static let maxPercentage: NSDecimal = 0.75
	private static func colorForPercentage(percentage: NSDecimal) -> UIColor {
		switch percentage {
		case maxPercentage: return .redColor()
		case _ where percentage > 0: return interpolateRGBA(from: colorForPercentage(0), to: colorForPercentage(maxPercentage), by: percentage.asCGFloat)
		case 0: return .blueColor()
		case -maxPercentage: return .greenColor()
		case _ where percentage < 0: return interpolateRGBA(from: colorForPercentage(0), to: colorForPercentage(-maxPercentage), by: -percentage.asCGFloat)
		default: fatalError("Switch shouldn't go here")
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
	func setHistory(history: [NSDecimal]) {
		dispatch_sync_main {
			
		}
	}
}

//MARK: - IBAction
extension MenuProductCell {
	static var selectedProductWithIdentifierActionName: Selector { return Selector("selectedProductWithIdentifier:") }
	@IBAction private func orderButtonTapped(sender: UIButton) {
		guard let productIdentifier = productIdentifier else { return }
		performActionOnResponderChain(MenuProductCell.selectedProductWithIdentifierActionName, withObject: productIdentifier)
	}
}
