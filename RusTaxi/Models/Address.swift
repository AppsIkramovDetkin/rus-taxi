//
//  Address.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 05.09.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

enum AddressState: Int, Codable {
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

enum AddressPosition: Int, Codable {
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

class Address: Codable {
	var pointName: String
	var country: String = ""
	var address: String = ""
	var position: AddressPosition
	var state: AddressState
	var response: SearchAddressResponseModel?
	
	init(pointName: String) {
		self.pointName = pointName
		self.position = AddressPosition.from(pointName: pointName)
		self.state = AddressState.from(pointName: pointName)
	}
	
	static func from(response: NearStreetResponseModel?, pointName: String = points[0]) -> Address? {
		guard let model = response else {
			return nil
		}
		
		let address = Address(pointName: pointName)
		address.country = model.Country ?? ""
		address.address = model.FullName ?? ""
		address.response = SearchAddressResponseModel.from(nearModel: model)
		return address
	}
	
	static func from(response: SearchAddressResponseModel?, pointName: String = points[0]) -> Address? {
		guard let model = response else {
			return nil
		}
		
		let address = Address(pointName: pointName)
		address.country = model.Country ?? ""
		address.address = model.FullName ?? ""
		address.response = response
		return address
	}
	
	
}
