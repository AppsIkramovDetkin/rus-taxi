//
//  UserManager.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

typealias UserInfoCallback = ((UserInfoModelResponse?) -> Void)

class UserManager: BaseManager {
	static let shared = UserManager()
	var loaded: VoidClosure?
	private(set) var lastResponse: UserInfoModelResponse?
	
	func getMyInfo(local_id: String = "", orderStatus: String = "", with completion: UserInfoCallback? = nil) {
		let json = [
			Keys.local_id.rawValue: local_id,
			Keys.status.rawValue: orderStatus
		]
		
		_ = request(with: .getUserInfo, with: json, and: [OrderManager.Keys.uuid_client.rawValue: Storage.shared.token])
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				
				let entity = try? self.decoder.decode(UserInfoModelResponse.self, from: json.rawData())
				self.lastResponse = entity
				completion?(entity)
				self.loaded?()
			})
	}
}

extension UserManager {
	enum Keys: String {
		case status = "status"
		case local_id = "uuidp"
	}
}
