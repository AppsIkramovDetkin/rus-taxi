//
//  SettingsCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 02.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
	@IBOutlet weak var priceTextField: UITextField!
	@IBOutlet weak var orderTimeButton: UIButton!
	@IBOutlet weak var payTypeButton: UIButton!
	@IBOutlet weak var wishesButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
