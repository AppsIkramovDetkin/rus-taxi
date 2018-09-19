//
//  NearCarRespones.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class NearCarResponse: Decodable {
	var uuid: String?
	var lat: Double?
	var lon: Double?
	var time_n: Int?
	var dist: Int?
	var direction: Int?
}
