//
//  NewOrderDataProvider.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import CoreLocation

@objc protocol NewOrderDataProviderObserver {
	@objc optional func requestChanged()
	@objc optional func precalculated()
	@objc optional func requestStarted()
	@objc optional func requestEnded()
}

class NewOrderDataProvider {
	static let shared = NewOrderDataProvider()
	private init() {
		request = NewOrderRequest()
		request.local_id = NSUUID().uuidString.lowercased()
		request.type_pay = "cash"
		request.booking_time = Date().addingTimeInterval(Time.zero.minutes(6).seconds).requestFormatted()
	}
	private let service = OrderManager.shared
	private(set) var request: NewOrderRequest {
		didSet {
			observers.forEach { $0.requestChanged?() }
		}
	}
	var priceResponse: CurrentMoneyResponse? {
		return OrderManager.shared.lastPriceResponse
	}
	var observers: [NewOrderDataProviderObserver] = []
	var tariffChanged: ItemClosure<String>?
	var priceChanged: ItemClosure<Double>?
	
	func cancelOrder(with causeId: Int, with completion: OptionalItemClosure<CancelOrderResponseModel>? = nil) {
		OrderManager.shared.cancelOrder(for: request.local_id ?? "", cause_id: causeId, with: completion)
	}
	
	func addObserver(_ observer: NewOrderDataProviderObserver) {
		observers.append(observer)
	}
	
	func onNearestTime() {
		request.nearest = true
	}
	
	func offNearestTime() {
		request.nearest = false
	}
	
	func clear() {
		request = NewOrderRequest()
	}
	
	func isFilled() -> Bool {
		return request.booking_time.isFilled
			&& request.source != nil
			&& (request.destination ?? []).count > 0
			&& request.tarif != nil
	}
	
	func precalculate(with completion: OptionalItemClosure<PreCalcResponse>? = nil) {
		observers.forEach { $0.requestStarted?() }
		OrderManager.shared.preCalcOrder(with: request) { (response) in
			self.observers.forEach { $0.requestEnded?() }
			self.observers.forEach { $0.precalculated?() }
			completion?(response)
		}
	}
	
	func inject(tariffs: [TarifResponse]) {
		request.all_tarif = tariffs.map { Tarif.init(tarif: $0) }
		request.tarif = request.all_tarif?.first?.uuid
	}
	
	func set(tariff: TarifResponse) {
		request.tarif = tariff.uuid ?? ""
	}
	
	func set(date: Date) {
		request.booking_time = date.requestFormatted()
	}
	
	func change(price: Double) {
		request.auction_money = price
		request.is_auction_enable = price > 0
		priceChanged?(price)
	}
	
	func set(wishes: [Tarif]) {
		request.requirements = wishes.map { Requirement.init(id: $0.uuid) }
	}
	
	func setSource(by addressModel: AddressModel) {
		request.source = addressModel
	}
	
	func change(dest: Int, with model: AddressModel) {
		guard let destinations = self.request.destination else {
			return
		}
		if destinations.contains(index: dest) {
			self.request.destination?[dest] = model
		} else {
			self.request.destination?.append(model)
		}
	}
	
	func post(with completion: NewOrderResponseClosure?) {
		observers.forEach { $0.requestStarted?() }
		OrderManager.shared.addNewOrder(with: request) { (response) in
			self.observers.forEach { $0.requestEnded?() }
			completion?(response)
		}
	}
}

extension Optional where Wrapped == String {
	var isFilled: Bool {
		return !(self?.isEmpty ?? true)
	}
}

extension Optional {
	var isNil: Bool {
		return self == nil
	}
}
