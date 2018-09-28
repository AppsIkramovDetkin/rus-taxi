//
//  CallTaxiCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 11.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class CallTaxiCell: UITableViewCell {
	@IBOutlet weak var callButton: UIButton!
	
	var callButtonClicked: VoidClosure?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		callButton.setTitle("ЗАКАЗАТЬ\nЭКОНОМ", for: .normal)
		callButton.titleLabel?.numberOfLines = 2
		callButton.addTarget(self, action: #selector(callButtonAction(sender:)), for: .touchUpInside)
	}
	
	@objc private func callButtonAction(sender: UIButton) {
		callButtonClicked?()
	}
}
