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
	static let shared = CustomButton()
	
	func toTrash(button: Button) {
		button.image = UIImage(named: "ic_menu_delete")
		button.removeTarget(nil, action: nil, for: .allEvents)
		button.layer.masksToBounds = false
		button.layer.shadowOffset = CGSize(width: 0, height: 0)
		button.layer.shadowColor = TaxiColor.black.cgColor
		button.layer.shadowOpacity = 0.23
		button.layer.shadowRadius = 4
	}
	
	func toMenu(button: Button) {
		button.image = UIImage(named: "ic_menu_sort_by_size")
		button.layer.masksToBounds = false
		button.layer.shadowOffset = CGSize(width: 0, height: 0)
		button.layer.shadowColor = TaxiColor.black.cgColor
		button.layer.shadowOpacity = 0.23
		button.layer.shadowRadius = 4
	}
	
	func toShare(button: Button) {
		button.image = UIImage(named: "ic_menu_share")
		button.removeTarget(nil, action: nil, for: .allEvents)
		button.layer.masksToBounds = false
		button.layer.shadowOffset = CGSize(width: 0, height: 0)
		button.layer.shadowColor = TaxiColor.black.cgColor
		button.layer.shadowOpacity = 0.23
		button.layer.shadowRadius = 4
	}
}
