//
//  OrderManager.swift
//  RusTaxi
//
//  Created by Danil Detkin on 14/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias NewOrderResponseClosure = ((NewOrderResponse?) -> Void)
class OrderManager: BaseManager {
	static let shared = OrderManager()
	
	func addNewOrder(with orderRequest: NewOrderRequest, with completion: NewOrderResponseClosure?) {
		let json = orderRequest.dictionary
		let req = request(with: .addNewOrder, with: json, and: [Keys.uuid_client.rawValue: Storage.shared.token])
		_ = req.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
			let responseModel = try? JSONDecoder.init().decode(NewOrderResponse.self, from: json.rawData())
			completion?(responseModel)
		})
	}
}

extension OrderManager {
	enum Keys: String {
		case uuid_client = "UUID_Client"
	}
}

extension Request {
	public func debugLog() -> Self {
		#if DEBUG
		debugPrint(self)
		#endif
		return self
	}
}
