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
	
	func configure(by model: SearchAddressResponseModel) {
		addressLabel.text = model.FullName
		countryLabel.text = model.Country
	}
	
	func set(hidden: Bool) {
		UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
			self.isHidden = hidden
		})
	}
}
