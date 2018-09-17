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
	var uuid_tmp: String = ""
	func activateClientPhone(prefix: String, phone: String, fio: String, with completion: ErrorStringClosure? = nil) {
		let formatedPhone = PhoneFormatterHelper.format(phone, with: .onlyWithPlus)
		let jsonParams = [
			Keys.fio.rawValue: fio,
			Keys.prefix.rawValue: prefix,
			Keys.phone_no_prefix.rawValue: formatedPhone.remove(text: prefix),
			Keys.phone.rawValue: formatedPhone
		]
		_ = request(with: .activateClientPhone, with: jsonParams)
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				self.uuid_tmp = json[Keys.uuid_tmp.rawValue].stringValue
				completion?(error, json[Keys.err_txt.rawValue].stringValue)
			})
	}
	
	func confirmCode(code: String, with completion: BoolStringClosure? = nil) {
		let jsonParams = [
			Keys.pin.rawValue: code
		]
		_ = request(with: .confirmPin, with: jsonParams, and: [Keys.uuid_tmp.rawValue: uuid_tmp])
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				Storage.shared.token = json[Keys.uuid.rawValue].stringValue
				
				completion?(json[BaseManager.BaseKeys.result.rawValue].stringValue == "done", json[Keys.err_txt.rawValue].stringValue)
			})
	}
}

extension AuthManager {
	enum Keys: String {
		case phone = "Phone"
		case realPhone = "RealPhone"
		case fio = "FIO"
		case prefix = "Prefix"
		case phone_no_prefix = "Phone_no_prefix"
		case uuid_tmp = "UUID_Tmp"
		case err_txt = "err_txt"
		case pin = "PIN"
		case uuid = "uuid"
	}
}
