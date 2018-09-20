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
	
	func set(wishes: [Tarif]) {
		request.requirements = wishes.map { Requirement.init(id: $0.uuid) }
	}
	
	func setSource(by addressModel: AddressModel) {
		request.source = addressModel
	}
	
	func change(dest: Int, with model: AddressModel) {
		self.request.destination?[dest] = model
	}
}
