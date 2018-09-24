//
//  AddressView.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 20.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class AddressView: UIView, NibLoadable {
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var countryLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		layer.shadowOffset = CGSize(width: 0, height: 3)
		layer.shadowOpacity = 0.2
		layer.shadowRadius = 3.0
		layer.shadowColor = TaxiColor.black.cgColor
	}
	
	func show() {
		UIView.animate(withDuration: 0.35) {
			self.transform = CGAffineTransform.identity
		}
	}
	
	func hide() {
		UIView.animate(withDuration: 0.35) {
			self.transform = self.transform.scaledBy(x: 0.01, y: 0.01)
		}
	}
	
	func configure(by model: SearchAddressResponseModel) {
		addressLabel.text = model.FullName
		countryLabel.text = model.Country
	}
}
