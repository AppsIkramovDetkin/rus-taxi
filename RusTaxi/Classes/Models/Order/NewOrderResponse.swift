//
//  NewOrderResponse.swift
//  RusTaxi
//
//  Created by Danil Detkin on 14/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class NewOrderResponse: Decodable {
	var result: String?
	var err_txt: String?
	var uuid: String?
	var local_id: String?
	var Status: String?
	var money_taxo: Double?
	var step_auction: Double?
}
