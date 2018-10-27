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
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		phoneTextField.underline()
	}
}
