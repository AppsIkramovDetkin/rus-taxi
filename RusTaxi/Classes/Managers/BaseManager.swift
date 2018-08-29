//
//  BaseManager.swift
//  RusTaxi
//
//  Created by Danil Detkin on 26/08/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseManager {
	let imea = "357258062975316"
	let appId = "6fb5213e73af49e9833d9b1cbb4a37cd"
	let version = "3.0.0.31"
	
	var url: String {
		return "http://212.34.63.52:20510/api_m/"
	}
	
	func request(with request: TaxiRequest, with json: Parameters, and mainParameters: Parameters = [:]) -> DataRequest {
		var parameters: Parameters = [
			BaseKeys.imea.rawValue: imea,
			BaseKeys.appID.rawValue: appId,
			BaseKeys.version.rawValue: version,
			BaseKeys.json.rawValue: JSONString.from(json)
		]
		
		mainParameters.forEach { (key, value) in
			parameters[key] = value
		}
		
		return Alamofire.request(url(with: request), method: .post, parameters: parameters, encoding: URLEncoding.default)
	}
	
	func url(with request: TaxiRequest) -> String {
		return url + request.rawValue
	}
}

extension BaseManager {
	enum TaxiRequest: String {
		case activateClientPhone = "ActivateClientPhone/"
		case confirmPin = "ActivateClientPIN/"
		
		var httpMethod: HTTPMethod {
			switch self {
			case .activateClientPhone, .confirmPin: return .post
			}
		}
	}
}

extension BaseManager {
	enum BaseKeys: String {
		case imea = "IMEA"
		case appID = "APPID"
		case version = "Ver"
		case json = "JSON"
		case result = "result"
	}
}
