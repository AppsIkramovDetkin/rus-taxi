//
//  NewOrderRequest.swift
//  RusTaxi
//
//  Created by Danil Detkin on 14/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

struct NewOrderRequest: Encodable {
	var local_id: String?
	var tarif: String? {
		didSet {
			NewOrderDataProvider.shared.tariffChanged?(tarif ?? "")
		}
	}
	var uuid_org: String?
	var all_tarif: [Tarif]?
	var type_pay: String?
	var card_num: String?
	var is_auction_enable: Bool = false
	var auction_money: Double?
	var nearest: Bool? = false
	var booking_time: String? // "yyyy-MM-dd hh:mm:ss
	var requirements: [Requirement]?
	var source: AddressModel?
	var destination: [AddressModel]? = []
}

extension Encodable {
	var dictionary: [String: Any] {
		return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
	}
}
