//
//  MenuModel.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Foundation



//MARK: - MenuModel
struct MenuModel {
	var products: [Product] = []
}
extension MenuModel: Equatable {}
func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
	return lhs.products == rhs.products
}

//MARK: - Product
extension MenuModel {
	struct Product {
		var identifier: UInt
		var name: String
		var basePrice: NSDecimal
		var currentPrice: NSDecimal
		var currentPercentVariation: NSDecimal
		var priceHistory: [NSDecimal]
		
		init(identifier: UInt, name: String, basePrice: NSDecimal, currentPrice: NSDecimal, currentPercentVariation: NSDecimal, priceHistory: [NSDecimal]) {
			self.identifier = identifier
			self.name = name
			self.basePrice = basePrice
			self.currentPrice = currentPrice
			self.currentPercentVariation = currentPercentVariation
			self.priceHistory = priceHistory
		}
	}
}
extension MenuModel.Product: Equatable {}
func == (lhs: MenuModel.Product, rhs: MenuModel.Product) -> Bool {
	return
		lhs.identifier == rhs.identifier &&
		lhs.name == rhs.name &&
		lhs.basePrice == rhs.basePrice &&
		lhs.currentPrice == rhs.currentPrice &&
		lhs.currentPercentVariation == rhs.currentPercentVariation &&
		lhs.priceHistory == rhs.priceHistory
}
