//
//  SearchAddressModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class SearchAddressResponseModel: Decodable, Encodable {
	var FullName: String?
	var ObjectName: String?
	var `Type`: String?
	var Country: String?
	var City: String?
	var Street: String?
	var Home: String?
	var lat: String?
	var lon: String?
	var Street_ID: String?
	var Home_ID: String?
	var comment: String?
}
