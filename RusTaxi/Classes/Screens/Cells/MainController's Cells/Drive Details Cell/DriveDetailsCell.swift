//
//  DriveDetailsCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 16.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class DriveDetailsCell: UITableViewCell {
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var kilometersLabel: UILabel!
	
	func configure(by response: CheckOrderModel) {
		priceLabel.text = "~\((response.money_order ?? 0))₽"
		kilometersLabel.text = "\((response.distance_order ?? 0)) км"
	}
}
