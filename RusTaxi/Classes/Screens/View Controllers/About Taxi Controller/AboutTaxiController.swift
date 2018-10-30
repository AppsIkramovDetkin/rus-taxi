//
//  AboutTaxiController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 28.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class AboutTaxiController: UIViewController {
	@IBOutlet weak var headLabel: UILabel!
	@IBOutlet weak var orderTaxiLabel: UILabel!
	@IBOutlet weak var claimsLabel: UILabel!
	@IBOutlet weak var thanksLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		headLabel.text = Localize("appForOrder")
		orderTaxiLabel.text = Localize("numberForOrder")
		claimsLabel.text = Localize("claims")
		thanksLabel.text = Localize("thanks")
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NavigationBarDecorator.decorate(self)
		navigationController?.setNavigationBarHidden(false, animated: true)
		self.title = Localize("aboutTaxi")
	}
}
