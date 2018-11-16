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
		
		headLabel.text = "appForOrder".localized
//			Localize("appForOrder")
		orderTaxiLabel.text = "numberForOrder".localized
//			Localize("numberForOrder")
		claimsLabel.text = "claims".localized
//			Localize("claims")
		thanksLabel.text = "thanks".localized
//			Localize("thanks")
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NavigationBarDecorator.decorate(self)
		navigationController?.setNavigationBarHidden(false, animated: true)
		self.title = "aboutTaxi".localized
//			Localize("aboutTaxi")
	}
}
