//
//  AddressView.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 20.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class AddressView: UIView, NibLoadable {
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var countryLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
	func set(hidden: Bool) {
		UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
			self.isHidden = hidden
		})
	}
}
