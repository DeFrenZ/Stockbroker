//
//  ViewController.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import UIKit



class MenuViewController: UIViewController {
	var model: MenuModel? {
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
		
	}
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		configureCell(cell, forItemAtIndexPath: indexPath)
	}
}
