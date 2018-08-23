//
//  Router.swift
//  RusTaxi
//
//  Created by Danil Detkin on 22/08/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

final class Router {
	static let shared: Router = Router()
	func root(_ window: inout UIWindow?) {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.rootViewController = SlideshowController()
	}
}
