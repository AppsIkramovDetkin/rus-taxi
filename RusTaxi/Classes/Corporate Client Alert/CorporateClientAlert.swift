//
//  CorporateClientAlert.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 28.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class CorporateClientAlert {
	static let shared = CorporateClientAlert()
	
	func showPayAlert(in viewController: UIViewController, with completion: @escaping(_ cashText: String, _ cardText: String) -> Void) {
		let alert = UIAlertController(title: Localize("enter"), message: Localize("corporateAlert"), preferredStyle:
			UIAlertControllerStyle.alert)
		alert.addTextField(configurationHandler: moneyHandler)
		alert.addTextField(configurationHandler: cardHandler)
		alert.addAction(UIAlertAction(title: Localize("cancel"), style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: Localize("done"), style: .default, handler: nil))
		viewController.present(alert, animated: true, completion:nil)
	}
	
	private func moneyHandler(textField: UITextField!) {
		if (textField) != nil {
			textField.placeholder = Localize("login")
		}
	}
	
	private func cardHandler(textField: UITextField!) {
		if (textField) != nil {
			textField.placeholder = Localize("password")
		}
	}
}
