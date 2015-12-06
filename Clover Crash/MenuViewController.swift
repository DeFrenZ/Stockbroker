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
			
			notifyUserIfNeeded()
		}
	}
	
	private var favoritedProductsIdentifiers: Set<String> = []
	static let favoritedTriggerAmount: NSDecimal = -0.1
	
	@IBOutlet private var productsCollectionView: UICollectionView!
}

//MARK: - Helpers
extension MenuViewController {
	private func productAtIndexPath(indexPath: NSIndexPath) -> MenuModel.Product? {
		return model?.products[indexPath.item]
	}
	private func notifyUserIfNeeded() {
		guard let model = model else { return }
		let favoritedProducts = model.products.filter({ self.favoritedProductsIdentifiers.contains($0.identifier) })
		let productsToNotify = favoritedProducts.filter({ $0.currentPercentVariation <= MenuViewController.favoritedTriggerAmount })
		guard !productsToNotify.isEmpty else { return }
		
		let messageStart: String
		switch productsToNotify.count {
		case 0: return
		case 1: messageStart = "\(productsToNotify[0].name) is "
		case 2: messageStart = "\(productsToNotify[0].name) and \(productsToNotify[1].name) are "
		default: messageStart = "\(productsToNotify[0].name) and \(productsToNotify.count - 1) others are "
		}
		let message = messageStart + "really cheap right now!"
		
		let notification = UILocalNotification()
		notification.alertTitle = message
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
		
		favoritedProductsIdentifiers.subtractInPlace(productsToNotify.map({ $0.identifier }))
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
	private func updateCollectionViewCellWidthToFullWidth() {
		guard
			let layout = productsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout,
			let fullWidth = view?.frame.width
		else { return }
		layout.itemSize.width = fullWidth
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		getMenu { [weak self] productsResult in
			guard let sself = self else { return }
			
			let products: [MenuModel.Product]
			do {
				products = try productsResult()
			} catch {
				print("REST error:", error)
				return
			}
			sself.updateProducts(products)
			
			AppDelegate.sharedPusherManager.subscribeToEvent(productUpdateEventName, onChannel: menuChannelName, withBlock: sself.updateModelWithJSON)
		}
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateUIWithBlock {
			self.updateCollectionViewCellWidthToFullWidth()
		}
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
		cell.setPercentage(product.currentPercentVariation)
		cell.setHistory(product.priceHistory)
		cell.setFavorited(product.favorited)
	}
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		configureCell(cell, forItemAtIndexPath: indexPath)
	}
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		collectionView.deselectItemAtIndexPath(indexPath, animated: true)
		guard var product = model?.products[safe: indexPath.item] else { return }
		product.favorited = !product.favorited
		if product.favorited {
			favoritedProductsIdentifiers.insert(product.identifier)
		} else {
			favoritedProductsIdentifiers.remove(product.identifier)
		}
		model?.products[indexPath.item] = product
	}
}

//MARK: - IBAction
extension MenuViewController {
	@IBAction private func selectedProductWithIdentifier(productIdentifier: NSString) {
		let productIdentifier = productIdentifier as String
		orderProductWithIdentifier(productIdentifier)
	}
}

//MARK: - Pusher
private let menuChannelName = "menu"
private let productUpdateEventName = "update"
extension MenuViewController {
	private func updateModelWithJSON(json: JSON) {
		print("Got Pusher JSON:", json)
		guard let newProducts = json.asArray?.flatMap({ try? MenuModel.Product(json: $0) }) else { return }
		updateProducts(newProducts)
	}
	private func updateProducts(newProducts: [MenuModel.Product]) {
		guard let currentProducts = model?.products else { return }
		var updatedProducts = currentProducts
		for var product in newProducts {
			product.favorited = favoritedProductsIdentifiers.contains(product.identifier)
			if let index = updatedProducts.indexOf({ $0.identifier == product.identifier }) {
				updatedProducts[index] = product
			} else {
				updatedProducts.append(product)
			}
		}
		model?.products = updatedProducts
	}
}
