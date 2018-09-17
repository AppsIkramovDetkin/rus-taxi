//
//  AppDelegate.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 21.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		Router.shared.root(&window)
		Fabric.with([Crashlytics.self])
//		AuthManager.shared.activateClientPhone(prefix: "+7", phone: "9181672810", fio: "Данил Деткин Дмитриевич") { (error, code) in
//			let code2 = (code ?? "").trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
//			print(code2)
//			AuthManager.shared.confirmCode(code: code2, with: { (success, error) in
//				print("success: \(success)")
//			})
//		}
		
//		AddressManager.shared.search(by: "Проспект", location: CLLocationCoordinate2D.init(latitude: 60.054528, longitude: 30.325014)) { (addresses) in
//
//		}
		IQKeyboardManager.shared.enable = true
//		let request = NewOrderRequest()
//		request.local_id = ID()
//		request.tariff = "F5E306B4-5573-469A-A40C-DBC4AB80AF96"
//		request.all_tarif = [Tarif(uuid: "F5E306B4-5573-469A-A40C-DBC4AB80AF96")]
//		request.type_pay = "cash"
//		request.card_num = "123"
//		request.is_auction_enable = false
//		request.nearest = true
//		request.uuid_org = ""
//		request.auction_money = 0
//
//		request.booking_time = Date().addingTimeInterval(65 * 32).requestFormatted()
//		request.requirements = []
//		let sourceAddress = AddressModel()
//		sourceAddress.country = "Россия"
//		sourceAddress.region = "Санкт-Петербург"
//		sourceAddress.street = "Хошимина"
//		sourceAddress.home = "16"
//		sourceAddress.porch = ""
//		sourceAddress.comment = ""
//		let endAddress = AddressModel()
//		endAddress.country = "Россия"
//		endAddress.region = "Санкт-Петербург"
//		endAddress.street = "Хошимина"
//		endAddress.home = "16"
//		endAddress.porch = ""
//		endAddress.comment = ""
//		request.source = sourceAddress
//		request.destination = [endAddress]
//
//		OrderManager.shared.addNewOrder(with: request, with: nil)
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}

extension Date {
	func requestFormatted() -> String {
		return self.convertFormateToNormDateString(format: "yyyy-MM-dd") + "T" + self.convertFormateToNormDateString(format: "HH:mm:ss")
	}
}
