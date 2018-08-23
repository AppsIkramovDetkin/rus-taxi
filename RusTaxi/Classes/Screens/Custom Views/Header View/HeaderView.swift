//
//  HeaderViewController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
	@IBOutlet weak var label: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		label.textColor = TaxiColor.gray
	}
}
