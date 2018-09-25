//
//  PriceCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 17.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PricesCell: UITableViewCell {
	@IBOutlet weak var risePriceButton: UIButton!
	@IBOutlet weak var fallPriceButton: UIButton!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var additionalPrice: UILabel!
	
	var minPriceClicked: VoidClosure?
	var plusPriceClicked: VoidClosure?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		fallPriceButton.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
		risePriceButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
	}
	
	@objc private func minusButtonClicked() {
		minPriceClicked?()
	}
	
	@objc private func plusButtonClicked() {
		plusPriceClicked?()
	}
}
