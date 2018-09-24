//
//  PayAlertController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 14.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PayAlertController {
	static let shared = PayAlertController()
	
	func showPayAlert(in viewController: UIViewController, with completion: @escaping(_ cashText: String, _ cardText: String) -> Void) {
		let alert = UIAlertController(title: Localize("payAlert"), message: nil, preferredStyle:
			UIAlertControllerStyle.alert)
		alert.addTextField(configurationHandler: moneyHandler)
		alert.addTextField(configurationHandler: cardHandler)
		alert.addAction(UIAlertAction(title: Localize("cancel"), style: .cancel, handler: nil))
		viewController.present(alert, animated: true, completion:nil)
	}
	
	private func moneyHandler(textField: UITextField!) {
		if (textField) != nil {
			textField.placeholder = Localize("cash")
			textField.text = "Этот экран не имеет функционала"
		}
	}
	
	private func cardHandler(textField: UITextField!) {
		if (textField) != nil {
			textField.placeholder = Localize("addCard")
			textField.text = "И будет добавлен в следующих этапах"
		}
	}
}
