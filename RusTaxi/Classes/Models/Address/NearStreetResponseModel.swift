//
//  NearStreetResponseModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 19/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class NearStreetResponseModel: Decodable {
	var result: String?
	var FullName: String?
	var ID: String?
	var ObjectName: String?
	var `Type`: String?
	var Country: String?
	var City: String?
	var Street: String?
	var home: String?
	var lat: String?
	var lon: String?
}
