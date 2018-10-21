//
//  File.swift
//  RusTaxi
//
//  Created by Danil Detkin on 21/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class MainControllerRouter {
	typealias Controller = MainController
	private let root: Controller
	
	init(root: Controller) {
		self.root = root
	}
	
	func showResultScreen() {
		let vc = EstimateController()
		root.navigationController?.pushViewController(vc, animated: true)
	}
}
