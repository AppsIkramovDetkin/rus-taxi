//
//  WishesCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 13.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class WishesCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var switcher: UISwitch!
	@IBOutlet weak var priceLabel: UILabel!
	
	var switchChanged: BoolClosure?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		switcher.addTarget(self, action: #selector(switchChangeAction(sender:)), for: .valueChanged)
	}
	
	@objc private func switchChangeAction(sender: UISwitch) {
		switchChanged?(sender.isOn)
	}
	
	func configure(by wish: Equip) {
		label.text = wish.name
		let price: String = {
			if let money = wish.money {
				return "\(money) ₽"
			} else {
				return ""
			}
		}()
		priceLabel.text = price
	}
}
