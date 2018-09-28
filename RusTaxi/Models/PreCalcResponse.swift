//
//  PreCalcResponse.swift
//  RusTaxi
//
//  Created by Danil Detkin on 28/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class PreCalcResponse: Decodable {
	var result: String?
	var err_txt: String?
	var money_o: String?
	var dist: String?
	var time: String?
	var all_trf: [PreCalcTariff]?
}

class PreCalcTariff: Decodable {
	var uuid: String?
	var money_o: Int?
	var info: String?
}

