//
//  orderTimeView.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 20.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class OrderTimeView: UIView {
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var checkButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var acceptButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		customizeDatePicker()
		customizeCheckButton()
	}
	
	private func customizeCheckButton() {
		checkButton.backgroundColor = .clear
		checkButton.layer.cornerRadius = 2
		checkButton.layer.borderWidth = 1
		checkButton.layer.borderColor = TaxiColor.purple.cgColor
	}
	private func customizeDatePicker() {
		datePicker.datePickerMode = .dateAndTime
	}
}
