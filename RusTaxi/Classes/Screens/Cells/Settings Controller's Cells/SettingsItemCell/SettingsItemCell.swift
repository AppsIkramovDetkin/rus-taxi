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
		
//		checkBoxButton.addTarget(self, action: #selector(checkBoxButtonClicked), for: .touchUpInside)
//		customizeButton()
	}
	
	private func customizeButton() {
		checkBoxButton.layer.cornerRadius = 2
		checkBoxButton.layer.borderWidth = 1
		checkBoxButton.layer.borderColor = TaxiColor.darkGray.cgColor
	}
	
//	@objc private func checkBoxButtonClicked() {
//		isOnCheckButton = !isOnCheckButton
//		if isOnCheckButton {
//			checkBoxButton.setImage(UIImage(named: "checking"), for: .normal)
//		} else {
//			checkBoxButton.setImage(UIImage(named: "noImage"), for: .normal)
//		}
//	}
}
