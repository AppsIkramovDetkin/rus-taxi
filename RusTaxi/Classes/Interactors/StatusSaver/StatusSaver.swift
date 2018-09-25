//
//  StatusSaver.swift
//  RusTaxi
//
//  Created by Danil Detkin on 25/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class StatusSaver {
	typealias Model = StatusModel
	static let shared = StatusSaver()
	private let key = "status_hash:da39a3ee5e6b4b0d3255bfef95601890afd80709"
	
	func save(_ model: Model) {
		Defaulter<Model>.save(model: model, for: key)
	}
	
	func retrieve() -> Model? {
		return Defaulter<Model>.retrieve(by: key)
	}
}


