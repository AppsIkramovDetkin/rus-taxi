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
	
	init(tarif: TarifResponse) {
		self.uuid = tarif.uuid!
	}
}

class TarifResponse: Decodable {
	var uuid: String?
	var name: String?
	var comment: String?
	var allow_auction: Int?
	var min_money: Double?
	var type_pays: [TypePay]?
	var equips: [Equip]?
}
