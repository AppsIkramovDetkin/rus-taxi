//
//  Defaulter.swift
//  RusTaxi
//
//  Created by Danil Detkin on 25/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

final class Defaulter<T: Codable> {
	static func save(model: T, for key: String) {
		let encoder = JSONEncoder()
		let entity = try? encoder.encode(model)
		defaults.set(entity, forKey: key)
		defaults.synchronize()
	}
	
	static func clear(for key: String) {
		defaults.removeObject(forKey: key)
		defaults.synchronize()
	}
	
	static func retrieve(by key: String) -> T? {
		let decoder = JSONDecoder()
		if let objectData = UserDefaults.standard.object(forKey: key) as? Data {
			return try? decoder.decode(T.self, from: objectData)
		}
		return nil
	}
}
