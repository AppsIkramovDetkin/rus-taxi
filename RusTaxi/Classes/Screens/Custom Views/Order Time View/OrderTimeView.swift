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
	
	var date: Date?
	
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
	
	@objc private func datePickerChanged() {
		let date = datePicker.date
		self.date = date
	}
	
	private func customizeDatePicker() {
		guard let currentDate = Calendar.current.date(byAdding: .minute, value: 6, to: Date()) else {
			return
		}
		datePicker.datePickerMode = .dateAndTime
		datePicker.minimumDate = currentDate
		datePicker.date = currentDate
		datePicker.minuteInterval = 5
		datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
		self.date = currentDate
	}
}
