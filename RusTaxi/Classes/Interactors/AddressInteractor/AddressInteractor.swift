//
//  AddressInteractor.swift
//  RusTaxi
//
//  Created by Danil Detkin on 28/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class AddressInteractor {
	typealias Model = RemindAddressModel
	static let shared = AddressInteractor()
	private init() {}
	private let key = "addreess_hash:da39a3ee5e6b4b0d3255bfef95601890afd80709"
	
	func remind(addresses: [SearchAddressResponseModel]) {
		var currentAddresses = Defaulter<[Model]>.retrieve(by: key) ?? []
		for address in addresses {
			let indexOfCurrent = currentAddresses.firstIndex { (remindModel) -> Bool in
				return remindModel.entity.FullName == address.FullName
			}
			
			if let index = indexOfCurrent {
				// address exist, must increment
				currentAddresses[index].numberOfUses += 1
			} else {
				currentAddresses.append(RemindAddressModel(address))
			}
		}
		
		Defaulter<[Model]>.save(model: currentAddresses, for: key)
	}
	
	func delete(_ model: Model) {
		var currentAddresses = Defaulter<[Model]>.retrieve(by: key) ?? []
		let indexOfCurrent = currentAddresses.firstIndex { (remindModel) -> Bool in
			return remindModel.entity.FullName == model.entity.FullName
		}
		guard let index = indexOfCurrent else {
			return
		}
		currentAddresses.remove(at: index)
		
		Defaulter<[Model]>.save(model: currentAddresses, for: key)
	}
	
	func retrieve() -> [Model] {
		return Defaulter<[Model]>.retrieve(by: key) ?? []
	}
}

class RemindAddressModel: Codable {
	var numberOfUses = 0
	var entity: SearchAddressResponseModel
	
	init(_ entity: SearchAddressResponseModel) {
		self.entity = entity
	}
}
