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
	private var request = NewOrderRequest()
	
	func clear() {
		request = NewOrderRequest()
	}
	
	func setSource(by addressModel: AddressModel) {
		request.source = addressModel
	}
}
