//
//  TaxiViewCollectionCel.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 09.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class TaxiViewCollectionCell: UICollectionViewCell {
	@IBOutlet weak var taxiView: UIView!
	@IBOutlet weak var nameTaxiLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var taxiImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeTaxiView()
	}
	
	func configure(by model: TarifResponse) {
		nameTaxiLabel.text = model.name
		priceLabel.text = "от \(model.min_money ?? 0) Р"
		taxiImageView.image = model.isSelected ? #imageLiteral(resourceName: "ic_standard_car_select") : #imageLiteral(resourceName: "ic_standard_car")
	}
	
	private func customizeTaxiView() {
		taxiView.layer.cornerRadius = 3
		taxiView.layer.borderWidth = 0.7
		taxiView.layer.borderColor = TaxiColor.lightGray.cgColor
		taxiView.clipsToBounds = true
		taxiView.layer.masksToBounds = true
		taxiView.layer.shadowOffset = .zero
		taxiView.layer.shadowOpacity = 0.5
		taxiView.layer.shadowRadius = 20
	}
}
