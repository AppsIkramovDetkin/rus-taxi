//
//  NavigationBarDecorator.swift
//  RusTaxi
//
//  Created by Danil Detkin on 21/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

final class NavigationBarDecorator {
	private init() {}
	
	static func decorate(_ vc: UIViewController) {
		vc.navigationController?.navigationBar.barTintColor = TaxiColor.orange
		vc.navigationController?.navigationBar.tintColor = TaxiColor.black
	}
}
