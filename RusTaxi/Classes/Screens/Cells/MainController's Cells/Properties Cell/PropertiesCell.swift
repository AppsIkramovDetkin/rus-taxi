//
//  PropertiesCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 17.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PropertiesCell: UITableViewCell {
	@IBOutlet weak var deliveryCarButton: UIButton!
	@IBOutlet weak var wishesButton: UIButton!
	@IBOutlet weak var payButton: UIButton!
	
	var orderTimeClicked: VoidClosure?

	override func awakeFromNib() {
		super.awakeFromNib()
		deliveryCarButton.addTarget(self, action: #selector(timeTriggerAction), for: .touchUpInside)
	}
	
	@objc private func timeTriggerAction() {
		orderTimeClicked?()
	}
}
