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
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		firstTextField.underline()
		secondTextField.underline()
	}
}
