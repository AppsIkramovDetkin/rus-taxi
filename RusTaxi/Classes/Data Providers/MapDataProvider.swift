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
	private var observers: [MapProviderObservable] = []
	
	var wishes: [Equip] {
		let selectedTarrifId = NewOrderDataProvider.shared.request.tarif
		var selectedTariff = UserManager.shared.lastResponse?.tariffs?.filter { $0.uuid == selectedTarrifId }.first
		if selectedTariff == nil {
			selectedTariff = UserManager.shared.lastResponse?.tariffs?.first
		}
		return selectedTariff?.equips ?? []
	}
	
	func addObserver(_ observer: MapProviderObservable) {
		observers.append(observer)
	}
	
	func startCheckingOrder(order_id: String, order_status: String, with completion: CheckOrderClosure? = nil) {
		let observingTime = Time.zero.seconds(10)
		timer.loop(on: observingTime) {
			OrderManager.shared.checkOrderModel(order_id: order_id, order_status: order_status, with: { [unowned self] response in
				self.observers.forEach { $0.orderRefreshed(with: response) }
				completion?(response)
			})
		}
	}
	
	func stopCheckingOrder() {
		timer.clear()
	}
}

protocol MapProviderObservable: class {
	func orderRefreshed(with orderResponse: CheckOrderModel?)
}
