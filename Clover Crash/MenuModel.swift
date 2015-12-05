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
		var imageURL: NSURL? = nil
		var price: NSDecimal
		
		init(identifier: UInt, name: String, imageURL: NSURL? = nil, price: NSDecimal) {
			self.identifier = identifier
			self.name = name
			self.imageURL =?? imageURL
			self.price = price
		}
	}
}
extension MenuModel.Product: Equatable {}
func == (lhs: MenuModel.Product, rhs: MenuModel.Product) -> Bool {
	return
		lhs.identifier == rhs.identifier &&
		lhs.name == rhs.name &&
		lhs.imageURL == rhs.imageURL &&
		lhs.price == rhs.price
}
