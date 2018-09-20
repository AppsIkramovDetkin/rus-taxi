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
	
	func findNearStreet(location: CLLocationCoordinate2D, closure: @escaping OptionalItemClosure<NearStreetResponseModel>) {
		let locationString = "\(location.latitude),\(location.longitude)"
		
		_ = request(with: .findNearStreet, and: [Keys.latlng.rawValue: locationString, ])
			.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
				let entity = try? self.decoder.decode(NearStreetResponseModel.self, from: json.rawData())
				print(json, request)
				closure(entity)
			})
	}
}

extension AddressManager {
	enum Keys: String {
		case lang = "lang"
		case latlng = "latlng"
		case lat = "Lat"
		case lon = "Lon"
		case streetId = "Street_ID"
		case street = "street"
	}
}
