//
//  Storage.swift
//  RusTaxi
//
//  Created by Danil Detkin on 14/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class Storage {
	static let shared = Storage()
	private init() {}
	private let defaults = UserDefaults.standard
	
	var token: String {
		get {
			return defaults.string(forKey: "token") ?? ""
		}
		
		set {
			defaults.set(newValue, forKey: "token")
			defaults.synchronize()
		}
	}
	
	func save(addressResponseModels: [SearchAddressResponseModel]) {
		defaults.set(addressResponseModels.map{$0.dictionary}, forKey: "responseModels")
		defaults.synchronize()
	}
	
	func savedAddressResponseModels() -> [SearchAddressResponseModel] {
		if let array = defaults.array(forKey: "responseModels") as? [[String : Any]] {
			return array.map({ (dict) -> SearchAddressResponseModel? in
				let entity = try? JSONDecoder().decode(SearchAddressResponseModel.self, from: NSKeyedArchiver.archivedData(withRootObject: dict))
				return entity
			}).compactMap{$0}
		}
		return []
	}
}
