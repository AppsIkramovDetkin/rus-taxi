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
	@IBOutlet weak var taxiImage: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeTaxiView()
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
