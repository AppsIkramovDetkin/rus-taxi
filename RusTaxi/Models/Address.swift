//
//  Address.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 05.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

enum AddressState {
	case `default`
	case add
	case delete
	
	static func from(pointName: String) -> AddressState {
		switch pointName {
		case points.first!:
			return AddressState.default
		case points[1]:
			return AddressState.add
		default:
			return AddressState.delete
		}
	}
}

enum AddressPosition {
	case top
	case middle
	case bottom
	
	static func from(pointName: String) -> AddressPosition {
		switch pointName {
		case points[0]:
			return AddressPosition.top	
		case points.last:
			return AddressPosition.bottom
		default:
			return AddressPosition.middle
		}
	}
}

class Address {
	var pointName: String
	var country: String = ""
	var address: String = ""
	var image: UIImage = #imageLiteral(resourceName: "ic_menu_add")
	var position: AddressPosition
	var state: AddressState
	
	init(pointName: String) {
		self.pointName = pointName
		self.position = AddressPosition.from(pointName: pointName)
		self.state = AddressState.from(pointName: pointName)
	}
}
