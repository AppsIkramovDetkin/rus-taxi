//
//  PreviousAddressCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 18.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PreviousAddressCell: UITableViewCell {
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var countryLabel: UILabel!
	@IBOutlet weak var anotherLabel: UILabel!
	@IBOutlet weak var verticalView: UIView!
	@IBOutlet weak var editButton: UIButton!
	
	var editButtonClicked: ItemClosure<SearchAddressResponseModel>?
	private var model: SearchAddressResponseModel?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		editButton.addTarget(self, action: #selector(editButtonAction(sender:)), for: .touchUpInside)
	}
	
	@objc private func editButtonAction(sender: UIButton) {
		if let entity = model {
			editButtonClicked?(entity)
		}
	}
	
	func configure(by model: SearchAddressResponseModel) {
		self.model = model
		addressLabel.text = model.FullName
		if let unboxCountry = model.Country, let unboxCity = model.City {
			countryLabel.text = "\(unboxCountry) \(unboxCity)"
		}
		anotherLabel.text = model.comment
		print("comment: \(anotherLabel.text)")
		print("porch: \(model.porch)")
	}
}
