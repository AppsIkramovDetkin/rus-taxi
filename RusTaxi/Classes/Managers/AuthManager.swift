//
//  AuthManager.swift
//  RusTaxi
//
//  Created by Danil Detkin on 26/08/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthManager: BaseManager {
	static let shared = AuthManager()
	
	func activateClientPhone(with phone: String, fio: String, with completion: ErrorClosure? = nil) {
		let parameters: Parameters = [
			BaseKeys.imea.rawValue: imea,
			BaseKeys.appID.rawValue: appId,
			Keys.fio.rawValue: fio,
			Keys.realPhone.rawValue: "",
			Keys.phone.rawValue: PhoneFormatterHelper.format(phone, with: .onlyWithPlus)
		]
		_ = request(with: .activateClientPhone, with: parameters)
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				print(json)
			})
	}
}

extension AuthManager {
	fileprivate enum Keys: String {
		case phone = "Phone"
		case realPhone = "RealPhone"
		case fio = "FIO"
	}
}
