//
//  ChatManager.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias MessagesClosure = (([MessageModel]) -> Void)

class ChatManager: BaseManager {
	static let shared = ChatManager()
	
	func dialDriver(orderId: String, order_status: String, with completion: OptionalItemClosure<String>? = nil) {
		_ = request(with: .dialDriver, with: [Keys.localId.rawValue: orderId, Keys.order_status.rawValue: order_status])
			.responseSwiftyJSON { (request, response, json, error) in
				completion?(json["err_txt"].string)
		}
	}
	
	func sendMessageToDriver(orderId: String, order_status: String, message: String, with completion: BoolClosure? = nil) {
		_ = request(with: .addMessage, with: [Keys.localId.rawValue: orderId, Keys.order_status.rawValue: order_status, Keys.message.rawValue: message])
			.responseSwiftyJSON { (request, response, json, error) in
				completion?(json.isTaxiDone())
		}
	}
	
	func getAllMessages(orderId: String, order_status: String, with completion: MessagesClosure? = nil) {
		_ = request(with: .getAllMessages, with: [Keys.localId.rawValue: orderId, Keys.order_status.rawValue: order_status])
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				let messages = json[Keys.listMessage.rawValue].map({ (object) -> MessageModel? in
					return try? self.decoder.decode(MessageModel.self, from: object.1.rawData())
				}).compactMap { $0 }
				completion?(messages)
			})
	}
}

extension ChatManager {
	enum Keys: String {
		case localId = "local_id"
		case order_status = "order_status"
		case message = "msg"
		case listMessage = "list_message"
	}
}

extension JSON {
	func isTaxiDone() -> Bool {
		return self["result"] == "done"
	}
}
