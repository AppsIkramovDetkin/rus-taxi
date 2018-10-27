//
//  CommentCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 12.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
	@IBOutlet weak var textField: UITextField!
	
	var textChanged: ItemClosure<String>?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textField.underline()
		textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
	}
	
	@objc private func textFieldChanged() {
		textChanged?(textField.text ?? "")
	}
}
