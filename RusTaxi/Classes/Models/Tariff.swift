//
//  Tariff.swift
//  RusTaxi
//
//  Created by Danil Detkin on 14/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class Tarif: Encodable {
	var uuid: String
	
	init(uuid: String) {
		self.uuid = uuid
	}
}
