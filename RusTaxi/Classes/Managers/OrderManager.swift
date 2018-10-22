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
	
	var lastPriceResponse: CurrentMoneyResponse?
	var lastPrecalculateResponse: PreCalcResponse?
	var priceClosure: OptionalItemClosure<CurrentMoneyResponse>?
	
	func cancelOrder(for local_id: String, cause_id: Int, with completion: OptionalItemClosure<CancelOrderResponseModel>? = nil) {
		let json: Parameters = [
			Keys.local_id.rawValue: local_id,
			Keys.cause_id.rawValue: cause_id
		]
		
		_ = request(with: .cancelOrder, with: json)
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				let responseModel = try? JSONDecoder.init().decode(CancelOrderResponseModel.self, from: json.rawData())
				completion?(responseModel)
			})
	}
	
	func confirmExit(local_id: String, order_status: String, closure: CheckOrderClosure? = nil) {
		_ = request(with: .checkOrder, with: [ChatManager.Keys.localId.rawValue: local_id, ChatManager.Keys.order_status.rawValue: order_status])
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				let entity = try? self.decoder.decode(CheckOrderModel.self, from: json.rawData())
				closure?(entity)
			})
	}
	
	func getPrice(for local_id: String, with completion: OptionalItemClosure<CurrentMoneyResponse>? = nil) {
		let json: Parameters = [
			Keys.local_id.rawValue: local_id
		]
		
		let req = request(with: .getCurrentMoney, with: json)
		_ = req.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
			let responseModel = try? JSONDecoder.init().decode(CurrentMoneyResponse.self, from: json.rawData())
			self.lastPriceResponse = responseModel
			self.priceClosure?(responseModel)
			completion?(responseModel)
		})
	}
	
	func setPrice(for local_id: String, money: Double, with completion: OptionalItemClosure<CurrentMoneyResponse>? = nil) {
		let json: Parameters = [
			Keys.local_id.rawValue: local_id,
			Keys.auction_money.rawValue: money
		]
		
		let req = request(with: .setCurrentMoney, with: json)
		_ = req.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
			let responseModel = try? JSONDecoder.init().decode(CurrentMoneyResponse.self, from: json.rawData())
			self.lastPriceResponse = responseModel
			self.priceClosure?(responseModel)
			completion?(responseModel)
		})
	}
	
	func addNewOrder(with orderRequest: NewOrderRequest, with completion: NewOrderResponseClosure? = nil) {
		var json = orderRequest.dictionary
		if let nearest = json["nearest"] as? Int {
			if nearest == 1 {
				json["nearest"] = true
			} else {
				json["nearest"] = false
			}
		}
		
		json[Keys.local_id.rawValue] = NSUUID().uuidString.lowercased()
		let req = request(with: .addNewOrder, with: json, and: [Keys.uuid_client.rawValue: Storage.shared.token])
		
		_ = req.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
			let responseModel = try? JSONDecoder.init().decode(NewOrderResponse.self, from: json.rawData())
			completion?(responseModel)
		})
	}
	
	func feedback(local_id: String, stars: Int, comment: String, causeIds: [Int], completion: VoidClosure? = nil) {
		
		let json: Parameters = [
			Keys.local_id.rawValue: local_id,
			Keys.stars.rawValue: stars,
			Keys.comment.rawValue: comment,
			Keys.cause_id.rawValue: causeIds.map{["id": $0]}
		]
		
		let req = request(with: .feedbackOrder, with: json, and: [Keys.uuid_client.rawValue: Storage.shared.token])
		_ = req.responseSwiftyJSON { (requst, response, json, error) in
			completion?()
		}
	}
	
	func preCalcOrder(with orderRequest: NewOrderRequest, with completion: OptionalItemClosure<PreCalcResponse>? = nil) {
		var json = orderRequest.dictionary
		json[Keys.local_id.rawValue] = NSUUID().uuidString.lowercased()
		let req = request(with: .preCalcOrder, with: json, and: [Keys.uuid_client.rawValue: Storage.shared.token])
		
		_ = req.responseSwiftyJSON(completionHandler: { (request, response, json, err) in
			let responseModel = try? JSONDecoder.init().decode(PreCalcResponse.self, from: json.rawData())

			self.lastPrecalculateResponse = responseModel
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
				print("json: \(json)")
				let entities = json[Keys.carList.rawValue].map { try? self.decoder.decode(NearCarResponse.self, from: $0.1.rawData()) }.compactMap{$0}
				completion?(entities)
			})
	}
}

extension OrderManager {
	enum Keys: String {
		case local_id = "local_id"
		case uuid_client = "UUID_Client"
		case tariffId = "tariff_UUID"
		case latitude = "Lat"
		case longitude = "Lon"
		case carList = "list_car"
		case auction_money = "auction_money"
		case cause_id = "cause_id"
		case stars = "raiting"
		case comment = "comment"
		case causeIds = "cause_ID"
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
