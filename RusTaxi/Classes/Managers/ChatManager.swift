//
//  ChatManager.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatManager: BaseManager {
	static let shared = ChatManager()
	
	//!! check is this method working
	func dialDriver(orderId: String, order_status: String, with completion: BoolClosure? = nil) {
		_ = request(with: .dialDriver, with: [Keys.localId.rawValue: orderId, Keys.order_status.rawValue: order_status])
			.responseSwiftyJSON { (request, response, json, error) in
				completion?(json.isTaxiDone())
		}
	}
	
	func sendMessageToDriver(orderId: String, order_status: String, message: String, with completion: BoolClosure? = nil) {
		_ = request(with: .addMessage, with: [Keys.localId.rawValue: orderId, Keys.order_status.rawValue: order_status, Keys.message.rawValue: message])
			.responseSwiftyJSON { (request, response, json, error) in
				completion?(json.isTaxiDone())
		}
	}
}

extension ChatManager {
	enum Keys: String {
		case localId = "local_id"
		case order_status = "order_status"
		case message = "msg"
	}
}

extension JSON {
	func isTaxiDone() -> Bool {
		return self["result"] == "done"
	}
}
