//
//  SearchAddressModel.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class SearchAddressResponseModel: Codable {
	var FullName: String?
	var ObjectName: String?
	var `Type`: String?
	var Country: String?
	var City: String?
	var Street: String?
	var Home: String? = ""
	var lat: String?
	var lon: String?
	var Street_ID: String?
	var Home_ID: String?
	var comment: String? = ""
	var porch: String? = ""
	
	static func from(nearModel: NearStreetResponseModel) -> SearchAddressResponseModel {
		let model = SearchAddressResponseModel()
		model.City = nearModel.City
		model.FullName = nearModel.FullName
		model.ObjectName = nearModel.ObjectName
		model.Type = nearModel.Type
		model.Country = nearModel.Country
		model.Street = nearModel.Street
		model.Home = nearModel.Home ?? ""
		model.comment = nearModel.comment
		model.porch = nearModel.porch
		model.lat = nearModel.lat
		model.lon = nearModel.lon
		model.Home_ID = nearModel.ID
		return model
	}
}
