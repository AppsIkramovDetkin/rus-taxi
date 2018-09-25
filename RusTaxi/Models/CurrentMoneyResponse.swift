//
//  SetCurrentMoneyResponse.swift
//  RusTaxi
//
//  Created by Danil Detkin on 25/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class CurrentMoneyResponse: Decodable {
	var result: String?
	var err_txt: String?
	var uuid: String?
	var local_id: String?
	var Status: String?
	var money_taxo: Double?
	var step_auction: Double?
	var add_disp_money: Double?
}
