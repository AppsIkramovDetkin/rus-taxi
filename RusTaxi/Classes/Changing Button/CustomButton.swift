//
//  ChangingButton.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 12.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import Material

class CustomButton: Button {
	func toTrash() {
		image = UIImage(named: "ic_menu_delete")
		removeTarget(nil, action: nil, for: .allEvents)
		layer.masksToBounds = false
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowColor = TaxiColor.black.cgColor
		layer.shadowOpacity = 0.23
		layer.shadowRadius = 4
	}
	
	@objc func toMenu() {
		image = UIImage(named: "ic_menu_sort_by_size")
		removeTarget(nil, action: nil, for: .allEvents)
		self.layer.masksToBounds = false
		self.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.layer.shadowColor = TaxiColor.black.cgColor
		self.layer.shadowOpacity = 0.23
		self.layer.shadowRadius = 4
	}
	
	func toShare() {
		image = UIImage(named: "ic_menu_share")
		removeTarget(nil, action: nil, for: .allEvents)
		layer.masksToBounds = false
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowColor = TaxiColor.black.cgColor
		layer.shadowOpacity = 0.23
		layer.shadowRadius = 4
	}
}
