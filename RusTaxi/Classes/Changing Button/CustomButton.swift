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
	func toTrash(selector: Selector, in vc: MainController) {
		removeTarget(nil, action: nil, for: .allEvents)
		image = UIImage(named: "ic_menu_delete")
		layer.masksToBounds = false
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowColor = TaxiColor.black.cgColor
		layer.shadowOpacity = 0.23
		layer.shadowRadius = 4
		addTarget(vc, action: selector, for: .touchUpInside)
	}
	
	@objc func toMenu() {
		image = UIImage(named: "ic_menu_sort_by_size")
		self.layer.masksToBounds = false
		self.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.layer.shadowColor = TaxiColor.black.cgColor
		self.layer.shadowOpacity = 0.23
		self.layer.shadowRadius = 4
	}
	
	func toShare() {
		image = UIImage(named: "ic_menu_share")
		layer.masksToBounds = false
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowColor = TaxiColor.black.cgColor
		layer.shadowOpacity = 0.23
		layer.shadowRadius = 4
	}
}
