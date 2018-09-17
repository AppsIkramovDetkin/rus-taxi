//
//  AddressManager.swift
//  RusTaxi
//
//  Created by Danil Detkin on 17/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation
import Alamofire

typealias AddresesResponseClosure = (([SearchAddressResponseModel]) -> Void)
class AddressManager: BaseManager {
	static let shared = AddressManager()
	
	func search(by text: String, location: CLLocationCoordinate2D, streetId: String? = nil, with completion: AddresesResponseClosure?) {
		var params: Parameters = [
			Keys.lang.rawValue: "ru",
			Keys.lat.rawValue: location.latitude,
			Keys.lon.rawValue: location.longitude,
			Keys.street.rawValue: text
		]
		
		if let id = streetId {
			params[Keys.streetId.rawValue] = id
		}
		
		_ = request(with: .findAddress, and: params)
		.responseSwiftyJSON { (request, response, json, error) in
			let addresess = json.map { mod in try? self.decoder.decode(SearchAddressResponseModel.self, from: mod.1.rawData())}.compactMap{$0}
			completion?(addresess)
		}
	}
}

extension AddressManager {
	enum Keys: String {
		case lang = "lang"
		case lat = "Lat"
		case lon = "Lon"
		case streetId = "Street_ID"
		case street = "street"
	}
}
