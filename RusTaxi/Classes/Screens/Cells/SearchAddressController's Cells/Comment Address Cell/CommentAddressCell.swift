//
//  CommentAddressCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 18.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class CommentAddressCell: UITableViewCell {
	@IBOutlet weak var commentTextField: UITextField!
	@IBOutlet weak var porchTextField: UITextField!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textFieldsUnderline()
	}
	
	private func textFieldsUnderline() {
		commentTextField.underline()
		porchTextField.underline()
	}
}
