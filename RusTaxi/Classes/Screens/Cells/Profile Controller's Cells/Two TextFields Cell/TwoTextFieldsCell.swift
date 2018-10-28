//
//  TwoTextFieldsCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class TwoTextFieldsCell: UITableViewCell {
	@IBOutlet weak var firstTextField: UITextField!
	@IBOutlet weak var secondTextField: UITextField!
	
	var firstTextFieldChanged: ItemClosure<String>?
	var secondTextFieldChanged: ItemClosure<String>?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		firstTextField.underline()
		secondTextField.underline()
		firstTextField.addTarget(self, action: #selector(firstTextFieldAction), for: .editingChanged)
		secondTextField.addTarget(self, action: #selector(secondTextFieldAction), for: .editingChanged)
	}
	
	@objc private func firstTextFieldAction() {
		firstTextFieldChanged?(firstTextField.text ?? "")
	}
	
	@objc private func secondTextFieldAction() {
		secondTextFieldChanged?(secondTextField.text ?? "")
	}
}
