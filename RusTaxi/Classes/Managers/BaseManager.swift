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
	let decoder = JSONDecoder.init()
	let imea = "357258062975316"
	let appId = "6fb5213e73af49e9833d9b1cbb4a37cd"
	let version = "3.0.0.31"
	
	var url: String {
		return "http://212.34.63.52:20510/api_m/"
	}
	
	func request(with request: TaxiRequest, with json: Parameters = [:], and mainParameters: Parameters = [:]) -> DataRequest {
		var parameters: Parameters = [
			BaseKeys.imea.rawValue: imea,
			BaseKeys.appID.rawValue: appId,
			BaseKeys.version.rawValue: version
		]
		
		if !json.isEmpty {
			parameters[BaseKeys.json.rawValue] = JSONString.from(json)
		}
		
		mainParameters.forEach { (key, value) in
			parameters[key] = value
		}
		print(request.rawValue)
		print(parameters)
		
		return Alamofire.request(url(with: request), method: request.httpMethod, parameters: parameters, encoding: URLEncoding.default)
	}
	
	func url(with request: TaxiRequest) -> String {
		let defaultURL = url + request.rawValue
		return defaultURL
	}
}

extension BaseManager {
	enum TaxiRequest: String {
		case activateClientPhone = "ActivateClientPhone/"
		case confirmPin = "ActivateClientPIN/"
		case addNewOrder = "AddNewOrderN1/"
		case findAddress = "FindAdrN2/"
		case dialDriver = "DialDriver/"
		case addMessage = "ChatAddMsgDriver/"
		case getAllMessages = "ChatGetMsgDriver/"
		case checkOrder = "ChkOrderN1/"
		case getUserInfo = "GetMyInfoN2/"
		case getNearCar = "GetNearCar/"
		case findNearStreet = "FindNearStreetN1/"
		case setCurrentMoney = "SetCurrentMoney/"
		case getCurrentMoney = "GetCurrentMoney/"
		
		var httpMethod: HTTPMethod {
			switch self {
			case .findNearStreet: return .get
			default: return .post
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
		case language = "language"
	}
}
