//
//  SettingsItemCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 28.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SettingsItemCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var checkBoxButton: UIButton!
	
	private var isOnCheckButton: Bool = true
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
	enum Language: String {
		case russian
		case english
	}
}
