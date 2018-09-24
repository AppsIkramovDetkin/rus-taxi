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
	@IBOutlet weak var wishesTriggerButton: UIButton!
	@IBOutlet weak var timeTriggerButton: UIButton!
	
	var wishesClicked: VoidClosure?
	var orderTimeClicked: VoidClosure?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		timeTriggerButton.addTarget(self, action: #selector(timeTriggerAction), for: .touchUpInside)
		wishesTriggerButton.addTarget(self, action: #selector(wishesTriggerAction), for: .touchUpInside)
	}
	
	@objc private func timeTriggerAction() {
		orderTimeClicked?()
	}
	
	@objc private func wishesTriggerAction() {
		wishesClicked?()
	}
}
