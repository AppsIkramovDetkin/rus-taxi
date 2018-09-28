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
		let encoder = JSONEncoder()
		let array = addressResponseModels.map{try? encoder.encode($0)}.compactMap { $0 }
		defaults.set(array, forKey: "responseModels")
		defaults.synchronize()
	}
	
	func savedAddressResponseModels() -> [SearchAddressResponseModel] {
		let decoder = JSONDecoder()
		if let questionData = UserDefaults.standard.array(forKey: "responseModels") as? [Data] {
			let array = questionData.map{try? decoder.decode(SearchAddressResponseModel.self, from: $0)}.compactMap{$0}
			return array
		}
		return []
	}
}
