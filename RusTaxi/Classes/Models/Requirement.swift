//
//  Requirement.swift
//  RusTaxi
//
//  Created by Danil Detkin on 14/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class Requirement: Encodable {
	var id: String
	
	init(id: String) {
		self.id = id
	}
}
