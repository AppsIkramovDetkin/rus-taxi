//
//  InputAddressCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 18.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class InputAddressCell: UITableViewCell {
	@IBOutlet weak var textField: UITextField!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textFieldUnderline()
	}
	
	private func textFieldUnderline() {
		textField.underline()
	}
}