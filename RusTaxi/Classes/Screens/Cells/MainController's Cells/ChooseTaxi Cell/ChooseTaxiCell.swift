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
		if indexPath.row == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taxiViewCell", for: indexPath) as! TaxiViewCollectionCell
			return cell
		} else if indexPath.row == 1 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taxiViewCell", for: indexPath) as! TaxiViewCollectionCell
			cell.nameTaxiLabel.text = Localize("webTaxi")
			cell.taxiImage.image = #imageLiteral(resourceName: "ic_standard_car")
			cell.priceLabel.text = "от 1000.0 р"
			return cell
		} else if indexPath.row == 2 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taxiViewCell", for: indexPath) as! TaxiViewCollectionCell
			cell.nameTaxiLabel.text = Localize("comfort")
			cell.taxiImage.image = #imageLiteral(resourceName: "ic_standard_car")
			cell.priceLabel.text = "от 220.0 р"
			return cell
		} else if indexPath.row == 3 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taxiViewCell", for: indexPath) as! TaxiViewCollectionCell
			cell.nameTaxiLabel.text = Localize("buisnessTaxi")
			cell.taxiImage.image = #imageLiteral(resourceName: "ic_standard_car")
			cell.priceLabel.text = "от 300.0 р"
			return cell
		}
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
}
