//
//  NewOrderDataProvider.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import CoreLocation

class NewOrderDataProvider {
	static let shared = NewOrderDataProvider()
	private init() {}
	private let service = OrderManager.shared
	private(set) var request = NewOrderRequest()
	
	func clear() {
		request = NewOrderRequest()
	}
	
	func isFilled() -> Bool {
		return request.booking_time.isFilled
			&& request.auction_money != nil
			&& request.source != nil
			&& (request.destination ?? []).count > 0
			&& request.tarif != nil
	}
	
	func inject(tariffs: [TarifResponse]) {
		request.all_tarif = tariffs.map { Tarif.init(tarif: $0) }
	}
	
	func set(tariff: TarifResponse) {
		request.tarif = tariff.uuid ?? ""
	}
	
	func set(date: Date) {
		request.booking_time = date.requestFormatted()
	}
	
	func change(price: Double) {
		request.auction_money = price
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
		OrderManager.shared.addNewOrder(with: request, with: completion)
	}
}

extension Optional where Wrapped == String {
	var isFilled: Bool {
		return !(self?.isEmpty ?? true)
	}
}
