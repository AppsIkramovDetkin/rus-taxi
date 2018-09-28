//
//  SourceModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 14/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import CoreLocation

class AddressModel: Encodable {
	var home_id: Int?
	var num: Int?
	var country: String?
	var region: String?
	var street: String?
	var home: String?
	var porch: String?
	var comment: String?
	var lat: CLLocationDegrees?
	var lon: CLLocationDegrees?
}

extension AddressModel {
	static func from(response: SearchAddressResponseModel) -> AddressModel {
		let model = AddressModel()
		model.home_id = Int(response.Home_ID ?? "")
		model.country = response.Country
		model.region = response.City
		model.street = response.Street
		model.home = response.Home
		model.comment = response.comment
		model.porch = response.porch
		model.lat = CLLocationDegrees(response.lat ?? "")
		model.lon = CLLocationDegrees(response.lon ?? "")
		return model
	}
}
