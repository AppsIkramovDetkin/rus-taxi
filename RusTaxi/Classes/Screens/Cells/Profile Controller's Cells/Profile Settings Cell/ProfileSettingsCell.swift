//
//  ProfileSettingsCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class ProfileSettingsCell: UITableViewCell {
	@IBOutlet weak var textField: UITextField!
	
	var textChanged: ItemClosure<String>?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textField.underline()
		textField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
	}
	
	@objc private func textFieldAction() {
		self.textChanged?(textField.text ?? "")
	}
	
}
