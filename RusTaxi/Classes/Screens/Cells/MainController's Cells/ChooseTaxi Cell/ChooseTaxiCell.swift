//
//  ChooseTaxiCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 09.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class ChooseTaxiCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
	@IBOutlet weak var collectionView: UICollectionView!
	private var tariffs: [TarifResponse] = {
		return UserManager.shared.lastResponse?.tariffs ?? []
	}()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		delegating()
		registerNib()
		UserManager.shared.loaded = {
			self.tariffs = UserManager.shared.lastResponse?.tariffs ?? []
			self.collectionView.reloadData()
			
		}
	}
	
	private func delegating() {
		collectionView.delegate = self
		collectionView.dataSource = self
	}
	
	private func registerNib() {
		collectionView.register(UINib(nibName: "TaxiViewCollectionCell", bundle: nil), forCellWithReuseIdentifier: "taxiViewCell")
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taxiViewCell", for: indexPath) as! TaxiViewCollectionCell
		cell.configure(by: tariffs[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		for model in tariffs {
			model.isSelected = false
		}
		tariffs[indexPath.row].isSelected = !tariffs[indexPath.row].isSelected
		
		NewOrderDataProvider.shared.set(tariff: tariffs[indexPath.row])
		collectionView.reloadData()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tariffs.count
	}
}
