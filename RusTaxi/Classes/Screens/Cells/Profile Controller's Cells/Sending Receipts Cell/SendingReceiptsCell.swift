//
//  SendingReceiptsCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 27.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class SendingReceiptsCell: UITableViewCell {
	@IBOutlet weak var checkBoxButton: UIButton!
	
	private var isOnCheckButton: Bool = true
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		checkBoxButton.layer.cornerRadius = 2
		checkBoxButton.layer.borderWidth = 1
		checkBoxButton.layer.borderColor = TaxiColor.darkGray.cgColor
		checkBoxButton.addTarget(self, action: #selector(checkBoxClicked), for: .touchUpInside)
	}
	
	@objc private func checkBoxClicked() {
		isOnCheckButton = !isOnCheckButton
		if isOnCheckButton {
			print("Test")
			checkBoxButton.setImage(UIImage(named: "checking"), for: .normal)
		} else {
			print("test2")
			checkBoxButton.setImage(UIImage(named: "noImage"), for: .normal)
		}
	}
}
