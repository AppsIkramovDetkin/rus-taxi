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
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textField.underline()
	}
}
