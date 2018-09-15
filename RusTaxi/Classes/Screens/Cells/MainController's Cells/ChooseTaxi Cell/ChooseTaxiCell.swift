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
	
	private let taxiTypeModels: [TaxiTypeModel] = [
	TaxiTypeModel.init(typeName: "Эконом", price: 90.0),
	TaxiTypeModel.init(typeName: "Web-Бизнес", price: 1000.0),
	TaxiTypeModel.init(typeName: "Комфорт", price: 220.0),
	TaxiTypeModel.init(typeName: "Бизнес", price: 300.0)]
	private let collectionLayout = UICollectionViewFlowLayout()
	override func awakeFromNib() {
		super.awakeFromNib()
		
		delegating()
		registerNib()
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
		cell.configure(by: taxiTypeModels[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		for model in taxiTypeModels {
			model.isSelected = false
		}
		taxiTypeModels[indexPath.row].isSelected = !taxiTypeModels[indexPath.row].isSelected
		collectionView.reloadData()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return taxiTypeModels.count
	}
}
