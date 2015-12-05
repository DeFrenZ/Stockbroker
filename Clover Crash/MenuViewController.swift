//
//  ViewController.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit



class MenuViewController: UIViewController {
	var model: MenuModel? = .emptyModel {
		didSet {
			guard let model = model where model != oldValue else { return }
			updateUIWithModel(model)
		}
	}
	
	@IBOutlet private var productsCollectionView: UICollectionView!
}

//MARK: - Helpers
extension MenuViewController {
	private func productAtIndexPath(indexPath: NSIndexPath) -> MenuModel.Product? {
		return model?.products[indexPath.item]
	}
}

//MARK: - UI
extension MenuViewController {
	private func updateUIWithModel(model: MenuModel) {
		updateUIWithBlock {
			self.productsCollectionView.reloadData()
		}
	}
}

//MARK: - UIViewController
extension MenuViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		AppDelegate.sharedPusherManager.subscribeToEvent(productUpdateEventName, onChannel: menuChannelName, withBlock: updateModelWithJSON)
	}
}

//MARK: - UICollectionViewDataSource
extension MenuViewController: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return model?.products.count ?? 0
	}
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCellWithReuseIdentifier(MenuProductCell.reuseIdentifier, forIndexPath: indexPath)
	}
}

//MARK: - UICollectionViewDelegate
extension MenuViewController: UICollectionViewDelegate {
	private func configureCell(cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		guard
			let productCell = cell as? MenuProductCell,
			let product = productAtIndexPath(indexPath)
		else { return }
		configureProductCell(productCell, forProduct: product)
	}
	private func configureProductCell(cell: MenuProductCell, forProduct product: MenuModel.Product) {
		cell.productIdentifier = product.identifier
		cell.setName(product.name)
		cell.setPrice(product.currentPrice)
	}
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		configureCell(cell, forItemAtIndexPath: indexPath)
	}
}

//MARK: - IBAction
extension MenuViewController {
	@IBAction private func selectedProductWithIdentifier(productIdentifier: NSNumber) {
		let identifier = productIdentifier.unsignedIntegerValue
		//TODO
	}
}

//MARK: - Pusher
private let menuChannelName = "menu"
private let productUpdateEventName = "update"
extension MenuViewController {
	private func updateModelWithJSON(json: JSON) {
		guard let newProducts = json.asArray?.flatMap({ try? MenuModel.Product(json: $0) }) else { return }
		updateProducts(newProducts)
	}
	private func updateProducts(newProducts: [MenuModel.Product]) {
		guard let currentProducts = model?.products else { return }
		var updatedProducts = currentProducts
		for product in newProducts {
			if let index = updatedProducts.indexOf({ $0.identifier == product.identifier }) {
				updatedProducts[index] = product
			} else {
				updatedProducts.append(product)
			}
		}
		model?.products = updatedProducts
	}
}
