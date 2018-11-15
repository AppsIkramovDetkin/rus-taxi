//
//  UserDefaultManager.swift
//  Eduson
//
//  Created by 1488 on 07.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class UserDefaultsManager {
	private struct Key {
		static let language = "com.eduson.user.language"
	}
	
	private let defaults = UserDefaults.standard
	static let shared = UserDefaultsManager()
	
	var language: String? {
		get {
			return defaults.object(forKey: Key.language) as? String
		}
		set {
			defaults.set(newValue, forKey: Key.language)
		}
	}
	
	var api_path: String {
		return "https://dev.eduson.tv/api/user/v2/"
	}
}
