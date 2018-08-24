//
//  NameCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
	@IBOutlet weak var textField: UITextField!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textFieldUnderLine()
	}
	
	private func textFieldUnderLine() {
		textField.underline()
	}
}
