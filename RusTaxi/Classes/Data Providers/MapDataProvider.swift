//
//  MapDataProvider.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class MapDataProvider {
	static let shared = MapDataProvider()
	private init() {}
	private let timer = TimerInteractor()
	
	func startCheckingOrder(order_id: String, order_status: String, with completion: CheckOrderClosure? = nil) {
		let observingTime = Time.zero.seconds(5)
		timer.loop(on: observingTime) {
			OrderManager.shared.checkOrderModel(order_id: order_id, order_status: order_status, with: completion)
		}
	}
	
	func stopCheckingOrder() {
		timer.clear()
	}
}
