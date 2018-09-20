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
import CoreLocation.CLLocation

typealias NewOrderResponseClosure = ((NewOrderResponse?) -> Void)
typealias CheckOrderClosure = ((CheckOrderModel?) -> Void)
typealias NearCarsCallback = (([NearCarResponse]) -> Void)

class OrderManager: BaseManager {
	static let shared = OrderManager()
	
	func addNewOrder(with orderRequest: NewOrderRequest, with completion: NewOrderResponseClosure? = nil) {
		let json = orderRequest.dictionary
		let req = request(with: .addNewOrder, with: json, and: [Keys.uuid_client.rawValue: Storage.shared.token])
		
		_ = req.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
			let responseModel = try? JSONDecoder.init().decode(NewOrderResponse.self, from: json.rawData())
			completion?(responseModel)
		})
	}
	
	func checkOrderModel(order_id: String, order_status: String, with completion: CheckOrderClosure? = nil) {
		_ = request(with: .checkOrder, with: [ChatManager.Keys.localId.rawValue: order_id, ChatManager.Keys.order_status.rawValue: order_status])
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				let entity = try? self.decoder.decode(CheckOrderModel.self, from: json.rawData())
				completion?(entity)
			})
	}
	
	func getNearCar(tariff_id: String, location: CLLocationCoordinate2D, with completion: NearCarsCallback?) {
		let params: Parameters = [
			Keys.uuid_client.rawValue: Storage.shared.token,
			Keys.tariffId.rawValue: tariff_id,
			Keys.latitude.rawValue: location.latitude,
			Keys.longitude.rawValue: location.longitude
		]
		_ = request(with: .getNearCar, and: params)
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				let entities = json[Keys.carList.rawValue].map { try? self.decoder.decode(NearCarResponse.self, from: $0.1.rawData()) }.compactMap{$0}
				completion?(entities)
			})
	}
}

extension OrderManager {
	enum Keys: String {
		case uuid_client = "UUID_Client"
		case tariffId = "tariff_UUID"
		case latitude = "Lat"
		case longitude = "Lon"
		case carList = "list_car"
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
