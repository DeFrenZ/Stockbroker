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
extension MenuModel {
	static var emptyModel: MenuModel {
		return MenuModel(products: [])
	}
}

//MARK: - Product
extension MenuModel {
	struct Product {
		var identifier: String
		var name: String
		var basePrice: NSDecimal
		var currentPrice: NSDecimal
		var currentPercentVariation: NSDecimal
		var priceHistory: [NSDecimal] = []
		
		init(identifier: String, name: String, basePrice: NSDecimal, currentPrice: NSDecimal, currentPercentVariation: NSDecimal, priceHistory: [NSDecimal]? = nil) {
			self.identifier = identifier
			self.name = name
			self.basePrice = basePrice
			self.currentPrice = currentPrice
			self.currentPercentVariation = currentPercentVariation
			self.priceHistory =?? priceHistory
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
extension MenuModel.Product {
	enum ParsingError: ErrorType {
		case Identifier, Name, BasePrice, SalePrice, PercentVariation
	}
	init(json: JSON) throws {
		guard let identifier = json["id"]?.asString else { throw ParsingError.Identifier }
		guard let name = json["name"]?.asString else { throw ParsingError.Name }
		guard let price = json["price"]?.asDecimal else { throw ParsingError.BasePrice }
		guard let salePrice = json["sale_price"]?.asDecimal else { throw ParsingError.SalePrice }
		guard let percentageChange = json["percentage_change"]?.asDecimal else { throw ParsingError.PercentVariation }
		guard let history = json["history"]?.asArray?.flatMap({ $0.asDecimal }) else { throw ParsingError.History }
		
		self.init(identifier: identifier, name: name, basePrice: price, currentPrice: salePrice, currentPercentVariation: percentageChange, priceHistory: history)
	}
}
