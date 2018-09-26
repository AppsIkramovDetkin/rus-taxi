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
	var addressModels: [Address] = []
	var lastCheckOrderResponse: CheckOrderModel?
	
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
	
	func startCheckingOrder(by model: StatusModel, with completion: CheckOrderClosure? = nil) {
		startCheckingOrder(order_id: model.local_id ?? "", order_status: model.status ?? "", with: completion)
	}
	
	func startCheckingOrder(order_id: String, order_status: String, with completion: CheckOrderClosure? = nil) {
		let observingTime = Time.zero.seconds(10)
		timer.loop(on: observingTime) {
			OrderManager.shared.checkOrderModel(order_id: order_id, order_status: order_status, with: { [unowned self] response in
				let model = StatusModel.init()
				model.local_id = order_id
				model.addressModels = self.addressModels
				model.status = response?.status
				StatusSaver.shared.save(model)
				self.lastCheckOrderResponse = response
				self.observers.forEach { $0.orderRefreshed(with: response) }
				
				OrderManager.shared.getPrice(for: order_id)
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
