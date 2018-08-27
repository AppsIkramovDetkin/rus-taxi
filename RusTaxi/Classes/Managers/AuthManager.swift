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
				completion?(error, json["err_txt"].stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
			})
	}
}

extension AuthManager {
	fileprivate enum Keys: String {
		case phone = "Phone"
		case realPhone = "RealPhone"
		case fio = "FIO"
		case prefix = "Prefix"
		case phone_no_prefix = "Phone_no_prefix"
	}
}
