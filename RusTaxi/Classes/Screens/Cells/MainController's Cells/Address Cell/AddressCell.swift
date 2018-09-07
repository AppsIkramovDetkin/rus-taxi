//
//  AddressCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 31.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell, NibLoadable {
	
	@IBOutlet weak var symbolView: UIView!
	@IBOutlet weak var symbolLabel: UILabel!
	@IBOutlet weak var addressTextField: UITextField!
	@IBOutlet weak var countryLabel: UILabel!
	@IBOutlet weak var actionButton: UIButton!
	@IBOutlet weak var topLineView: UIView!
	@IBOutlet weak var botLineView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeSymbolView()
		countryLabel.text = "..."
		addressTextField.placeholder = Localize("address")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		symbolView.layer.cornerRadius = symbolView.frame.size.width/2
	}
	
	func configure(by model: Address) {
		symbolLabel.text = model.pointName
		addressTextField.text = model.address
		countryLabel.text = model.country
	}
	
	private func customizeSymbolView() {
		symbolView.clipsToBounds = true
		symbolView.layer.borderColor = TaxiColor.lightGray.cgColor
		symbolView.layer.borderWidth = 2
	}
}
