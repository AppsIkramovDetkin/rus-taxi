//
//  PhoneFormatterHelper.swift
//  RusTaxi
//
//  Created by Danil Detkin on 26/08/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

enum PhoneFormat {
	case onlyWithPlus
}

class PhoneFormatterHelper {
	static func format(_ phone: String, with format: PhoneFormat) -> String {
		switch format {
		case .onlyWithPlus:
			if phone.hasPrefix("+7") {
				return "+" + phone.lowercased()
													.components(separatedBy: CharacterSet.decimalDigits.inverted)
													.joined()
			} else {
				var newPhone = phone
				newPhone.removeFirst()
				return "+7" + newPhone.lowercased()
													.components(separatedBy: CharacterSet.decimalDigits.inverted)
													.joined()
			}
		}
	}
}
