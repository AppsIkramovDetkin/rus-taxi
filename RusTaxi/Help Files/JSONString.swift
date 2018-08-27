//
//  JSONString.swift
//  RusTaxi
//
//  Created by Danil Detkin on 27/08/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import Alamofire

class JSONString {
	static func from(_ value: Parameters) -> String {
		var str = "{"
		var index = 0
		for object in value {
			if index == 0 {
				str += "\"\(object.key)\":\"\(object.value)\""
			} else {
				str += ",\"\(object.key)\":\"\(object.value)\""
			}
			index += 1
		}
		str += "}"
		return str
	}
}
