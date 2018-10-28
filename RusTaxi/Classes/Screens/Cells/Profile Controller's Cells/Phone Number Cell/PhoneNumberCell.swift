//
//  PhoneNumberCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PhoneNumberCell: UITableViewCell {
	@IBOutlet weak var prefixLabel: UILabel!
	@IBOutlet weak var phoneTextField: UITextField!
	
	var textChanged: ItemClosure<String>?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		phoneTextField.underline()
		phoneTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
	}
	
	@objc private func textFieldChanged() {
		textChanged?(phoneTextField.text ?? "")
	}
}
