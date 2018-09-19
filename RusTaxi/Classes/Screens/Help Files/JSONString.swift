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
		func brackets(_ value: Any) -> String {
			return "\"\(value)\""
		}
		var str = "{"
		var index = 0
		for object in value {
			let obj: Any = {
				if let dict = object.value as? [Parameters] {
					return array(dict)
				} else if let dict = object.value as? Parameters {
					return from(dict)
				} else {
					return brackets(object.value)
				}
			}()
			if index == 0 {
				str += "\"\(object.key)\":\(obj)"
			} else {
				str += ",\"\(object.key)\":\(obj)"
			}
			index += 1
		}
		str += "}"
		return str
	}
	
	static func array(_ array: [Parameters]) -> String {
		var str = "["
		var index = 0
		for element in array {
			if index == array.count - 1 {
				str += from(element)
			} else {
				str += "\(from(element)),"
			}
			index += 1
		}
		str += "]"
		return str
	}
}

